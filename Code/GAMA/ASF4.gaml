/***
* Name: ASF01
* Author: jpablo91
* Description: SIR For one Hexagon Works
* Next steps: Incorporate the movements between hexagons
* Tags: Tag1, Tag2, TagN
***/

model ASF01

global{
	// Simulation Steps
	float step <- 1 #day;
	int current_day update: int(time/#day);
	//int current_month update: int(time/#month);
	
	//Load the files:
	file Hx_shp <- file("../includes/FarmsHx.shp");
	
	geometry shape <- envelope(Hx_shp);
	
	// Disease Parameters
	int Init_I <- 1; // Number of initial infected
	float Infected;
	float Recovered;
	float Susceptible;
	float beta <- 0.4/step; // Transmission Rate
	
	// Movements
	int N_Trucks ;
	
	init{
		create Hx from: Hx_shp  with: [id_Nbs::(list<string>(string(read("Nbs")))), p_Mov::float(read("Out"))/450, p_Loops::float(read("Loops"))/450];
		// Loop to get the neighbor list
		ask Hx {
                loop n_id over: id_Nbs {
                    add (Hx first_with (each.idhex = n_id) ) to: Nbs;
             }
             Nbs[] >>- nil; // Remove the nil
        }     
        ask Init_I among Hx{
        	I <- 1.0;
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
	int Popultn;
	float t; //Variable to represent the discrete time for integration
   	int N <- Popultn; //Total Population 
	float I; //Number of infected
	float S <- N - I; //Number of susceptible
	float R <- 0.0; //Number of recovered
	//Disease Parameters
  	float local_beta <- (beta * p_Loops) + (0.0001/step);
   	float gamma <- 0.01/step; //Recovery Rate
   	float I_p;
   	float Export_p;
   	float CV;
   	rgb Color <- rgb(0, 0, 0,255);

   	float h <- 0.1*step;
   	string mm <- "Euler";
   	
   	//--------------EQUATIONS--------------//
	equation eqSIR type:SIR vars: [S,I,R, t] params: [N,local_beta, gamma];
	
	//--------------ACTIONS--------------//
	// Create a shipment
	action CreateShipment{
		create Truck{
			location <- myself.location;
			Origin <- myself;
			Destination <- myself.Nb;
			T <- Destination.location;
			N_Head <- poisson(myself.E_Anmls);
			myself.Popultn <- myself.Popultn - N_Head;
			if flip(myself.I_p){
				is_infected <- true;
			}
		}
	}
	// Scale to Action
	action ScaleTo (float Mn, float Mx, float x, float y){
		y <- ((1/cos(x) - 1/cos(0)) / (1/cos(1) - 1/cos(0))) * ((Mx - Mn) + Mn);
	}
	
	//--------------REFLEXES--------------//
	// Epidemic
	reflex epidemic when: I >0 {
		solve eqSIR method: mm step_size:h;
		I_p <- I/N;
		// Get a function of the exporting probability based on the proportion of infected
		do ScaleTo Mn:0.0 Mx:1.0 x:I_p y:Export_p;
		CV <- ((I - 0) / (5000 - 0)) * ((255 - 0) + 0);
		Color <- rgb(CV, 0, 0,255);
	}
	// Movements
	reflex Move{
		if flip(p_Mov){
			Nb <- one_of(Nbs);
			do CreateShipment;
			Out <- Out + 1;
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
	bool is_infected;
	
	
 //--------------REFLEXES--------------//
	// Go to Destination
	reflex GotoDestination{
		do goto target:T;
		if T = location{
			ask Destination{
				In <- In + 1;
				if myself.is_infected{
					I <- I + 1.0;
				}
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

