/**
* Name: ASF11
* FARM level model 
* Author: jpablo91
* Tags: 
*/
model ASF11
import "Interventions.gaml"

global{
	//~~~~~~ simulation steps: ~~~~~~
	float step <- 1 #day;
	int current_day update: int(time/#day);
	int scenario <- 0; // scenario 0 = baseline, 1 = movement restrictions and zoning
	// Load files:
	file Hx_shp <- file("../includes/out/Hx.shp");
	geometry shape <- envelope(Hx_shp);
	int SimLength <- 60;
	
	//~~~~~~ Disease Parameters ~~~~~~
	// Pigs
	int Init_I <- 1; // Number of initial infected
	float Susceptible_P;
	float Infected_P update: Hx sum_of(each.I_P);
	float Recovered_P;
	float Beta_p <- 0.5/step; // Transmission rate for pigs
	float Gamma_p <- 0.001/step; // Base detection rate
	
	// Wild Boars
	//	int Init_I <- 1; // Number of initial infected
	float Susceptible_WB;
	float Infected_WB update: float(Hx sum_of(each.I_wb));
	float Recovered_WB;
	float Beta_wb <- 0.05/step; // Transmission rate for wild boars
	float Gamma_wb <- 0.001/step;
	float Transmission_d;
	float AdjSpreadWB_p <- 0.3; // probability of adjacent spread via WB
	
	
	init{
		create Hx from:Hx_shp with:[N_wb::int(read("E_WB"))*1, I_P::int(read("ph_cass")), I_wb::int(read("wb_cass"))]{
			Nbs_adj <- Hx at_distance 1#m;			
		}
		// Initial infection:
		ask Init_I among Hx{
//			I_P <- 1.0;
//			I_wb <- 1.0;
		}
		
		// Obtain the neighbors:
		// Trade Nbs
		matrix<int> m <- csv_file("../includes/out/MovHx.csv", true) as matrix<int>;
		loop elt over: rows_list(m){
			Hx n <- Hx first_with(each.idhex = elt[1]);
			add (Hx first_with(each.idhex = elt[2])) to: n.Nbs_trade;
		}
		// Contiguous Nbs
		
		create interventions;
	}
	
	reflex Count{
		Infected_P <- Hx sum_of(each.I_P);
		Recovered_P <- Hx sum_of(each.R_P);
		//Export results
		save [cycle, Infected_P, Infected_WB] to: "../results//EC/EpiCurve" + int(self) + seed +".csv" type:"csv" rewrite:false;
		
		if cycle = (SimLength - 1){
				ask Hx{
					save[cycle, idhex, Disease_status, introduction_ph, introduction_wb, infection_source] to: "../results/Agents/Hx" + int(myself) + ".csv" type:csv rewrite:false;
				}
			}
		
	}
	
	reflex StopSim when: cycle > SimLength#cycles{
		do pause;
	}
}

//=====================SPECIES: HEXAGON=====================//
species Hx{
	//~~~~~~ Population Parameters: ~~~~~~
	int Farms;
	float Mov;
	int out;
	int in;
	int idhex;
	int Pop;
	Hx Dest;
	list<Hx> Nbs_trade;
	list<Hx> Nbs_adj;
	float E_anmls;
//	int E_WB;
	int N_wb;
	float dnsty_s;
	float WB_scor;
	float p_Adj_Spread <- WB_scor*AdjSpreadWB_p;
	int introduction_ph;
	int introduction_wb;
	string infection_source;
	
	// Pigs Disease parameters
	float pigherd;
	float t;
	float h <- 0.1*step;
	float I_P <- pigherd;
	float S_P <- Farms - I_P;
	float R_P;
	rgb Color <- rgb(0, 0, 0, 255);
	float Export_p;
	float local_Bp <- dnsty_s/step;
	float local_gamma_p <- Gamma_p;
	
	// WB disease parameters
	float S_wb <- N_wb - I_wb;
	float I_wb;
	float R_wb;
	
	string Disease_status;
	// interventions
	float p_detection_ph <- dnsty_s/10;
	float p_detection_wb;
	
	bool wb_detected;
	bool ph_detected;
	bool movement_restrictions;
	
	
	
   	//--------------EQUATIONS--------------//
	// Usiing built in equaations
	equation SIR_P type:SIR vars: [S_P,I_P,R_P, t] params: [Farms, local_Bp, local_gamma_p];
	equation SIR_WB type:SIR vars: [S_wb,I_wb,R_wb, t] params: [N_wb, Beta_wb, Gamma_wb];
	
	
	//~~~~~~~ Actions:~~~~~~~~
	// Scale to Action
	action ScaleTo (float Mn, float Mx, float x, float y){
		y <- ((1/cos(x) - 1/cos(0)) / (1/cos(1) - 1/cos(0))) * ((Mx - Mn) + Mn);
	} 
	// Create a shipment
	action Ship{
		Dest <- one_of(Nbs_trade);
		Dest.in <- Dest.in + 1;
		
		if flip(Export_p){
			Dest.I_P <- Dest.I_P + 1;
			introduction_ph <- introduction_ph + 1;
			infection_source <- self.name;
		}
		out <- out + 1;
	}
	
	//~~~~~~~~~~~~~~~~Pig herds epidemic
	reflex epidemic_ph when: I_P >0{
		Disease_status <- "Epidemic";
		solve SIR_P method: "Euler" step_size:h;
		 float CV <- ((I_P - 0) / (25 - 0)) * ((255 - 0) + 0);
		 Color <- rgb(CV, 0, 0, 255);
		 if Pop > 0{
		 	float Infected_p <- I_P/Pop;
		 	Export_p <- Infected_p;
		 }
		 //baseline probability of detection
		 if (flip(p_detection_ph) and !ph_detected){
		 	ph_detected <- true;
		 	local_gamma_p <- Gamma_p*10;
//		 	movement_restrictions <- true;
		 	
		 }
	}
	
	//~~~~~~~~~~~wild boars epidemic
	reflex epidemic_wb when: I_wb > 0{
		solve SIR_WB method: "Euler" step_size:h;
		 // Probability of Wildlife-domestic transmission
		 float InfectedWB_p <- I_wb/N_wb;
		 if flip(InfectedWB_p/15){
		 	I_P <- I_P + 1;
		 	introduction_wb <- introduction_wb + 1;
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
		if flip(p_Adj_Spread/4){
			ask one_of(Nbs_adj){
				I_wb <- I_wb + 1.0;
				S_wb <- S_wb - 1.0;
				}
			
		}
			
	}
	
	//~~~~~~~ Geometry:~~~~~~~~
	aspect geom{
		draw shape color: Color border: ph_detected? #blue:#black;
	}
}

experiment main type:gui{
	output{
		layout #split consoles: true editors: false navigator: false tray: false tabs: false;
		display map{
			species Hx aspect: geom;
			species interventions;
		}
		display EpiCurve{
			chart "SI" type: series{
				data "Infected Pigs" value:Infected_P color: rgb (231, 124, 124,255);
				data "Recovered Pigs" value:Recovered_P color: rgb (0, 128, 0,255);
				data "Infected WildBoars" value:Infected_WB color: rgb (145, 0, 0,255);
				
			}
		}
		
	}
}


experiment Batch type:batch repeat: 50 until: cycle = SimLength{
}