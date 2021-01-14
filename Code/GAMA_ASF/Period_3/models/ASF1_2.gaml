/**
* Name: ASF13
* FARM level model 
* Author: jpablo91
* Tags: 
*/
model ASF11
import "Interventions.gaml"

global{
	//~~~~~~ simulation steps: ~~~~~~
	float seed <- int(self) + 2.0;
	float step <- 1 #day;
	int current_day update: int(time/#day);
	/*
	 * Scenarios:
	 * 0 = Baseline
	 * 1 = Hunting pressure
	 * 2 = Protection zones culling
	 * 3 =  wild boar culling
	 * 4 =  increaased surveillance zones
	 * 5 = contact tracing
	 */
	int Scenario <- 0;
	// Load files:
	file Hx_shp <- file("../includes/out/Hx_5000.shp");
	file Fence_shp <- file("../includes/out/fenceSp.shp");
	geometry shape <- envelope(Hx_shp);
	int SimLength <- 260;
	
	
	//~~~~~~ Disease Parameters ~~~~~~
	// Pigs
	int Init_I <- 1; // Number of initial infected
	float Susceptible_P min: 0.0;
	float Infected_P update: Hx sum_of(each.I_P) min: 0.0;
	float Death_P;
	float Removed_P min: 0.0;
	float Beta_p <- 0.6/step; // Transmission rate for pigs
	float Gamma_p <- 0.005/step; // Base detection rate
	
	// Wild Boars
	//	int Init_I <- 1; // Number of initial infected
	float Susceptible_WB update: float(Hx sum_of(each.S_wb));
	float Infected_WB update: float(Hx sum_of(each.I_wb));
	float Recovered_WB;
	float Hunted_WB;
	float Beta_wb <- 0.001/step; // Transmission rate for wild boars
	float Gamma_wb <- 0.001/step; 
	float Transmission_d;
	float AdjSpreadWB_p <- 0.1; // probability of adjacent spread via WB
	
	// Interventions
	bool MovRestriction;
	bool HuntingPressure;
//	float HuntingEffect <- 0.10;
	float HuntingPressureSpeed <- 50.0;
	float AwarenessEffect <- 1.5;
	bool Fencing;
	bool PZ_culling; // culling of all pig herds in protection zones (3 km, a.k.a 5 km in our model)
	bool WBZ_culling; // Culling of pig herds located <3km around detected positive wb carcasses
	bool IncreasedSurv; 
	bool ContactTracing;
	int Repopulation_t <- 60;
	
	
	init{
		write 'seed: ' + seed;
		// The csv file headers must be without "" marks, i.e. [setosa] not ["setosa"]
		create Hx_I from:csv_file("../includes/out/MovHx_c-5000.csv", true) with:
		[i::string(get('sourceHx')), 
			name::string(get('sourceHx')), 
			Nb_i::(list<string>(read("Nbs")))
		]{
			Nb_i>-first(Nb_i); //Remove first and last element (not sure why is reading with a first element as" '/')
			Nb_i>-last(Nb_i);
		}
		
		create Hx from:Hx_shp with:[N_wb::int(read("E_WB"))*9, I_P::int(read("ph_cases")), I_wb::int(read("wb_cases")), dnsty_s::float(read('density_s'))*1.5, p_detection_wb::float(read('WBd'))]{
			// Contiguous neighbors
			Nbs_adj <- Hx at_distance 1#m;	
			Nbs15k <- Hx at_distance 14#km;
			// find corresponding Hx_i index
			Hx_i <- Hx_I first_with(each.i = idhex);			
					
		}
		
		create Fence from:Fence_shp;
		// Initial infection:
		ask Init_I among Hx{
//			I_P <- 1.0;
//			I_wb <- 1.0;
		}
		
		// Obtain the neighbors:
		// Trade Nbs
		matrix<int> mc <- csv_file("../includes/out/MovHx_c.csv", true) as matrix<int>;
		
		// INTERVENTIONS
		create interventions;
		Fencing <- true;
		AwarenessEffect <- 30.0;
		MovRestriction <- true;
		WBZ_culling <- true;
		// Set scenarios
		if Scenario = 1{
			HuntingPressure <- true;
//			 WBZ_culling <- true;
		} 
		if Scenario = 2 {
			HuntingPressure <- true;
//			 WBZ_culling <- true;
		}
		if Scenario = 3{
			HuntingPressure <- true;
			 WBZ_culling <- true;
			
		}
		if Scenario = 4{
			HuntingPressure <- true;
			IncreasedSurv <- true;
		}
		if Scenario = 5{
			HuntingPressure <- true;
			ContactTracing <- true;
		}
	}
	
	reflex ph_culling_on when: cycle = 0{
		PZ_culling <- true; //Switch to wildboar culling !!!!!!!!!!!!!!!!!!!!!!!!
	}
	
	
	reflex Count{
		Infected_P <- Hx sum_of(each.I_P);
		Removed_P <- Hx sum_of(each.R_P);
		Death_P <- Hx sum_of(each.D_P);
		Hunted_WB <- Hx sum_of(each.H_wb);
		//Export results
		save [cycle, Infected_P, Infected_WB] to: "../results//EC/EpiCurve" + int(self) + seed +".csv" type:"csv" rewrite:false;
		
		if cycle = (SimLength - 1){
				ask Hx{
					save[cycle, idhex, Disease_status, reintroduction, introduction_ph, introduction_wb, infection_source] to: "../results/Agents/Hx" + int(myself) + ".csv" type:csv rewrite:false;
				}
			}
		
	}
	
	reflex StopSim when: cycle > SimLength#cycles{
		do pause;
	}
}

species Hx_I schedules:[]{
	list<string> Nb_i <- [];
	string i;
}

//=====================SPECIES: HEXAGON=====================//
species Hx{
	Hx_I Hx_i;
	//~~~~~~ Population Parameters: ~~~~~~
	float Farms;
	float initFarms <- Farms;
	float Mov;
	int out;
	int in;
	string idhex;
	float Pop;
	Hx Dest;
	list<Hx> Nbs_trade;
	list<int> Nbs_t;
	list<Hx> Nbs_adj;
	list<Hx> Nbs15k;
	float E_anmls;
	float N_wb;
	float dnsty_s;
	float WBd;
	float WB_scor;
	float p_Adj_Spread <- WB_scor*AdjSpreadWB_p;
	int introduction_ph;
	int introduction_wb;
	string infection_source;
	float outdoor;
	list<Hx> RecentNbs;
	// Reintroduction
	int disease_free_t;
	int reintroduction;
	
	// Pigs Disease parameters
	float pigherd;
	float t;
	float h <- 0.1*step;
	float I_P <- pigherd;
	float S_P <- Farms - I_P;
	float R_P;
	float D_P;
	float u_ph; // <- culling rate for pig herds
	rgb Color <- rgb(0, 0, 0, 255);
	float Export_p;
	float local_Bp <- (dnsty_s)/step;
	float local_gamma_p <- Gamma_p;
	bool is_epidemic;
	
	// WB disease parameters
	float S_wb <- N_wb - I_wb;
	float I_wb;
	float R_wb;
	float local_gamma_wb <- Gamma_wb;
	float u_wb; // <- mortality of wild boars (used for the hunting pressure speed)
	float H_wb; // Hunted wild boars
	
	string Disease_status;
	// interventions
	float p_detection_ph <- dnsty_s/10;
	float p_detection_wb;
	
	bool wb_detected;
	bool ph_detected;
	bool movement_restrictions;
	float WB_Dp <- outdoor*2;
	bool in_Fence;
	
	int Wb_i;
		
   	//--------------EQUATIONS--------------//
   	// Equation for pig herds
	 equation SIR_P{
	 	diff(S_P,t) = (-local_Bp * S_P*I_P/Farms) - (u_ph*S_P);
	 	diff(I_P,t) = (local_Bp * S_P * I_P / Farms) - (local_gamma_p*I_P) - (u_ph*I_P);
	 	diff(R_P,t) = (local_gamma_p*I_P) + (u_ph*S_P) + (u_ph*I_P); // Removed ph
	}
	// Equation for wild boars
	equation SIR_WB{
	 	diff(S_wb,t) = (-Beta_wb * S_wb*I_wb/N_wb) - (u_wb*S_wb);
	 	diff(I_wb,t) = (Beta_wb * S_wb * I_wb / N_wb) - (local_gamma_wb*I_wb) - (u_wb*I_wb);
	 	diff(R_wb,t) = (local_gamma_wb*I_wb) + (u_wb*S_wb) + (u_wb*R_wb);
	}
	
	//~~~~~~~ Actions:~~~~~~~~
	// Scale to Action
	action ScaleTo (float Mn, float Mx, float x, float y){
		y <- ((1/cos(x) - 1/cos(0)) / (1/cos(1) - 1/cos(0))) * ((Mx - Mn) + Mn);
	} 
	// Create a shipment
	action Ship{
		if length(Hx_i.Nb_i) > 0 {			
			string Dest_i <- one_of(Hx_i.Nb_i);
			Dest <- Hx first_with(each.idhex = Dest_i);
//			write "Hx :" + name + " to: " + Dest;
			Dest.in <- Dest.in + 1;
			Dest.RecentNbs <+ self;
		// Exporting a infected pig
		if flip(Export_p*2){
			Dest.I_P <- Dest.I_P + 1;
			Dest.introduction_ph <- Dest.introduction_ph + 1;
			infection_source <- self.name;
			write "Long distance transmission " + self.name + "-" + Dest.name + "at:" + cycle;
		}
		out <- out + 1;			
		}
		
	}
	
	//~~~~~~~~~~~~~~~~Pig herds epidemic
	reflex epidemic_ph when: I_P >0{
		if(Disease_status = "Recovering" or Disease_status = "Reinfection"){
			Disease_status <- "Reinfection";
			reintroduction <- reintroduction + 1;
		} else {
			Disease_status <- "Epidemic";
		}
		is_epidemic <- true;
		disease_free_t <- 0;
		solve SIR_P method: "Euler" step_size:h;
		 float CV <- ((I_P - 0) / (25 - 0)) * ((255 - 0) + 0);
//		 Color <- rgb(CV, 0, 0, 255);
		 if Pop > 0{
		 	float Infected_p <- I_P/Pop;
		 	Export_p <- Infected_p;
		 }
		 //If detected, the surveillance will increase 10 fold
		 if (flip(p_detection_ph) and !ph_detected){
		 	ph_detected <- true;
		 	local_gamma_p <- Gamma_p*AwarenessEffect; // increased awareness (Vet visits)

//		 	write "Detected in " + name + 'at day:' + cycle;
		 	if MovRestriction{ // Implement MOVEMENT RESTRICTIONS intervention [protection zone]
		 		movement_restrictions <- true;
		 		
		 		// Increased surveillance intervention.
		 		if IncreasedSurv{// if increased surveillance [Intervention IV] 
		 				ask Nbs15k{ 
		 			movement_restrictions <- true; // Implement the intervention for the farms < 15 km (adjacent Hx) [surveillance zone]
		 			local_gamma_p <- Gamma_p*AwarenessEffect; // increased aawareness for surveillance zone
		 			}
		 		} else {
		 			ask Nbs_adj{ 
		 			movement_restrictions <- true; // Implement the intervention for the farms < 10 km (adjacent Hx) [surveillance zone]
		 			local_gamma_p <- Gamma_p*AwarenessEffect; // increased aawareness for surveillance zone
		 			}
		 		}
		 	}
		 	// Contact tracing intervention
		 	if ContactTracing{
		 		if length(RecentNbs) > 0{
		 			ask RecentNbs{
		 				u_ph <- 0.05/step;
		 			}
		 		}
		 	}
		 	// Protection zone culling 	
		 	if PZ_culling{
		 		u_ph <- 0.05/step;
		 	}	
		 }
		 
		 if I_P < 1 {
		 	I_P <- 0.0;
		 	Disease_status <- "Recovering";
		 }
	}	
	reflex Repopulate{
		if disease_free_t = Repopulation_t{
			Farms <- initFarms;
		}
	}
	
	reflex UpdateStatus{
		if I_P > 0{
			Color <- #red;
		}
	}
	
	//~~~~~~~~~~~ wild boars epidemic
	reflex epidemic_wb when: I_wb > 0{
		solve SIR_WB method: "Euler" step_size:h;
		// Probability of wb detection
		if flip(p_detection_wb) and !wb_detected{
			wb_detected <- true;
//			write "WB detected in: " + name + " at " + cycle;
			if WBZ_culling and Farms > 0{
				u_ph <- 0.01/step;
//				Farms <- 0.0;
//				S_P <- 0.0;
//				I_P <- 0.0;
//				R_P <- 0.0;
				if Farms < 0 {
					Farms <- 0.0;
					write "Depopulation in :" + string(self) + " at " + cycle; 
				}
			}
		}
		
		 // Probability of Wildlife-domestic transmission
		 float InfectedWB_p <- I_wb/N_wb; //
		
		 if flip(WB_Dp) and Pop > 0{ // Probability of wildlife-domestic contact
		 	Wb_i <- int(rnd(1, N_wb));	// pick a random number that represent the index of a animal
		 	if(Wb_i < I_wb){ // If the index of the animal is > than the number of infeted the disease will be transmitted
		 		I_P <- I_P + 1;
		 		introduction_wb <- introduction_wb + 1;
//		 		write "Wildlife-Domestic transmission at: " + self;
		 	}
		 }
		 
		 if I_wb < 1{
		 	I_wb <- 0.0;
		 }	 
		}
	
	
		//~~~~~~~ Send shipments
	reflex SendShipment{
		if (flip(Mov) and !movement_restrictions){
			do Ship;
		}
	}
	
	//Contiguous transmission
	reflex Local_transmission when: I_wb > 0{
		if flip(p_Adj_Spread/2){
			ask one_of(Nbs_adj){
				I_wb <- I_wb + 1.0;
				S_wb <- S_wb - 1.0;
//				write "Adj Spread" + myself.name + "-" + self.name;
				}
			
		}
			
	}
	
	//~~~~~~~ Geometry:~~~~~~~~
	aspect geom{
		draw shape color: Color border: ph_detected? #blue:#black;
//		draw shape color: is_epidemic? #red:#black border: ph_detected? #blue:#black;
	}
}

experiment main type:gui{
	output{
		layout #split consoles: true editors: false navigator: false tray: false tabs: false;
		display map{
			species Hx aspect: geom;
			species interventions;
			species Fence aspect:geom;
		}
		display PH_Curve{
			chart "SI" type: series{
				data "Infected Pigs" value:int(Infected_P) color: rgb (231, 124, 124,255);
				data "Removed Pigs" value:Removed_P color: rgb (0, 128, 0,255);
//				data "Infected WildBoars" value:Infected_WB color: rgb (145, 0, 0,255);
				data "Death Pigs" value:int(Death_P) color: rgb (200, 200, 200,255);
			}
		}
		display WB_Curve{
			chart "SI" type: series{
//				data "Susceptible WildBoars" value:Susceptible_WB color: rgb (0, 145, 90,255);
				data "Infected WildBoars" value:Infected_WB color: rgb (145, 0, 0,255);
				data "Hunted WB" value:int(Hunted_WB) color: rgb (200, 200, 200,255);
			}
		}
		
	}
}


experiment Batch type:batch repeat: 20 until: cycle = SimLength{
}