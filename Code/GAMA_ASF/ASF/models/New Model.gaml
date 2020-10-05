/***
* Name: ASFOC2
* Author: ocords
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model ASFOC2

/* Insert your model definition here */
// ADD culling from infected farm; culling within range; surveillance after x time step, disinfection of pens
//distance between initial outbreak - batch processing - tells gama how many times to run, can export as csv
/***
* Name: ASF01
* Author: jpablo91
* Description: SIR For one Hexagon Works
* Next steps: Incorporate the movements between hexagons
* Tags: Tag1, Tag2, TagN
***/

global{
	// Simulation Steps
	float step <- 1 #day;
	int current_day update: int(time/#day);
	//int current_month update: int(time/#month);
	
	//Load the files:
	file Hx_shp <- file("data_wb_join.shp");


	geometry shape <- envelope(Hx_shp);
	
	// Disease Parameters
	int Init_I <- 1000; // Number of initial infected
	float Infected;
	float Recovered;
	float Susceptible;
	float beta <- 0.4/step; // Transmission Rate
	// Movements
	int N_Trucks ;
	
	init{
		// Determinstic simulation
		seed<-42;
		
		create Hx from: Hx_shp  with: [
			id_Nbs::(list<string>(string(read("Nbs")))), 
			p_Mov::float(read("Out"))/335, 
			p_Loops::float(read("Loops"))/335,
			N::int(read("tna")),
			Out::int(read("Out")),
			E_Anmls::float(read("n_dprtd"))/max(float(read("Out")), 1),
			dscale::float(read("dscale")),
			density::float(read("density")),
			wb::float(read("SUM"))
		];
		// Loop to get the neighbor list
		ask Hx {
             loop n_id over: id_Nbs {
                    add (Hx first_with (each.idhex = n_id) ) to: Nbs;
                    
             }
             Nbs[] >>- nil; // Remove the nil
             do CalcLocalBeta;
		 	 hx_nbs <- Hx select ((each distance_to self) < 10);
        }     
        ask Init_I among where (Hx, each.Out > 1 ) {
        	I <- min(100.0, N);
        	S <- N -I;
        }
	}
	
	reflex Count{
		Infected <- Hx sum_of(each.I);	
		Recovered <- Hx sum_of(each.R);
		Susceptible <- Hx sum_of(each.S);	
	}
	reflex StopSimulation when: cycle > 365*5#cycles{
		do pause;
	}
}


//=====================SPECIES: HEXAGON=====================//
species Hx{
	string idhex;
	// Movement parameters
	list id_Nbs;
	list<Hx> Nbs;
	float E_Anmls;
	float p_Mov;
	float p_Loops;
	int In;
	int Out;
	Hx Nb;
	// Population Parameters
	float t; //Variable to represent the discrete time for integration
   	int N;
	float I; //Number of infected
	float S <- N - I - R; //Number of susceptible
	float R <- 0.0; //Number of recovered
	float density;
	float dscale; //(z-scored density)
	float wb; //sum of wild boar in hexagon
	list<Hx> hx_nbs; //neighbors nearby
	//Disease Parameters
  	float local_beta;
  	float beta_wild_boar;
   	float gamma <- 0.01/step; //Recovery Rate
   	float I_p;
   	float Export_p;
   	float CV;
   	rgb Color <- rgb(0, 0, 0,255);
   	float h <- 1*step;
   	string mm <- "Euler";
   	
   	//--------------EQUATIONS--------------//
	//equation eqSIR type:SIR vars: [S,I,R, t] params: [N,local_beta, gamma];
	
	//--------------ACTIONS--------------//
	// Create a shipment
	action CreateShipment{
		create Truck{
			location <- myself.location;
			Origin <- myself;
			Destination <- myself.Nb;
			T <- Destination.location;
			N_Head <- min(poisson(myself.E_Anmls), myself.N);
			if (N_Head = 0) {
				return;
			}
			//All sick pigs are in range 0 to I
			//All recovered pigs are in range I to I + R
			//All health pigs are in range I+R to N
			num_infected <- 0;
			num_recovered <-0;
			list<int> shipped <- list_with(N_Head, -1); //initializes list with N entries w -1
			loop i from: 0 to: N_Head - 1 {
				int x <- rnd(0, myself.N - 1); //picks random number from 0 to N-1, which corresponds to a pig index
				loop while: (shipped contains x) { //make sure that the pig hasn't been selected before (equivalent to selected w/o replacement)
					x <- rnd(0, myself.N - 1);
				}
				shipped[i] <- x; //add pig to list of selected pig
				if (x < myself.I) { //pigs from 0 to I will be the sick pigs, I to N is healthy; if pig we selected is less than I then it's sick
					num_infected <- num_infected + 1;
				}
				else if (x < myself.I + myself.R) { //all recovered pigs are in range I:I+R
					num_recovered <- num_recovered +1;
				}
			}
			
			if num_infected > 0 {
				write "N " + myself.N + " N shipped " + N_Head + " I " + myself.I; 
				myself.I <- max(0, myself.I - num_infected);
				write "I update" + myself.I;
			}
			num_infected <- num_infected;
			myself.N <- myself.N - N_Head;
			myself.R <- myself.R - num_recovered;
			myself.S <- myself.S - (N_Head - num_infected - num_recovered); 
			if (myself.N = 0) {
				write "N is zero " + N_Head  + " " + myself.I + " " + myself.idhex;
				myself.I <- 0;
				myself.R <- 0;
				myself.S <- 0;
			}
		}
	}
	
	//--------------REFLEXES--------------//
	// local Epidemic
		
	equation eqSIR {
	    diff(S,t) = (-local_beta * S * I / N);
	    diff(I,t) = (local_beta * S * I / N) - (gamma * I);
	    diff(R,t) = (gamma * I);
	}	
	reflex epidemic when: I >0 {
		solve eqSIR method: mm step_size:h;
		if (N = 0) {
			write "N is zero2 " + I + " " + idhex;
		}
		I_p <- I/N; //used to set color of the hexagon
		
		if (N < 20) {
			CV <- I_p * 50;
		} else {
            CV <- I_p*255;			
		}
		Color <- rgb(CV, 0, 0,255);
	}
	
	action CalcLocalBeta { 
		local_beta <- (beta * p_Loops) + (0.0001/step); //changes beta based on probability of movement within the hexagon 
		if dscale < 0 {
			local_beta <- local_beta * 1/(-dscale + 1); //changes beta based on z-score densitys within the hexagon
		} else {
			local_beta <- local_beta * (dscale + 1);
		}
		
		// Wild boars
		int sick_nbs <- 0; //keeps track if neighboring hexagons are sick
		loop nb over: hx_nbs {
			if (nb.I > 0) {
			   sick_nbs <- sick_nbs + 1;
			}
			if (I >0) {
				sick_nbs <- sick_nbs +1;
			}
		}
		
		float wb_contribution <- 1 + wb/10;
		float sick_nbs_contribution <- 1 + sick_nbs /10;
		local_beta <- local_beta * wb_contribution * sick_nbs_contribution; //updates local beta to include sick boar and sick neighbors;
	}
	
	//reflex update local beta (includes wild boar, internal movements, and domestic density
	reflex UpdateLocalBeta {
	   do CalcLocalBeta;
	}
	
	// Movements
	reflex Move{
		if flip(p_Mov){
			Nb <- one_of(Nbs);
			if (N > 0) {
			  do CreateShipment;
			  Out <- Out + 1;
			}
		}
	}
   	
 //--------------ASPECT--------------//
	aspect geom{
		draw shape color:Color;
	}
}

//=====================SPECIES: TRUCK=====================//
species Truck skills:[moving]{
 //--------------ATTRIBUTES--------------//
	point T;
	int N_Head;
	Hx Origin;
	Hx Destination;
	int num_infected;
	int num_recovered;
	
	
 //--------------REFLEXES--------------//
	// Go to Destination
	reflex GotoDestination{
		do goto target:T;
		if T = location{
			ask Destination{
				In <- In + 1;
				if myself.num_infected >0 {
					I <- I + myself.num_infected;
					write "num sick " + myself.num_infected;
				}
				N <- N + myself.N_Head;
				R <- R + myself.num_recovered;
				S <- S + myself.N_Head - myself.num_infected - myself.num_recovered;
			}
			do die;
		}
	}
	
//--------------ASPECT--------------//
	aspect geom{
		draw square(1#km) color:#red;
	}
		
}


//=====================EXPERIMENT: GUI=====================//
experiment MapGUI type:gui{
	output{
		layout #split;
		display Map{
			species Hx aspect: geom;
			species Truck aspect:geom;
		}
		display EpiCurve{
			chart "SI" type: series{
				data "Susceptible" value: Susceptible color: #green;
				data "Infected" value: Infected color: #red;
				data "Recovered" value: Recovered color: #blue;
			}
		}
	}
}
/* Insert your model definition here */

