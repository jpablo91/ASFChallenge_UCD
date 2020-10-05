/**
* Name: Interventions
* Based on the internal empty template. 
* Author: jpablo91
* Tags: 
*/
@no_experiment

model Interventions
import "ASF1_2.gaml"

species interventions{
	list<Hx> InfectedHx;
	list<Hx> DetectedHx update: Hx where(each.ph_detected);
	
	// ~~~~~~~~~Pig Herd interventions
	// delays can be up to 3 days
	// next day culling, repopulation allowed after 50 days
	// Zoning: movement restriction for protection and surveillance zone; 
	// restrictions for herds that had commerce with infected herds in the previous 3 weeks
	// farms in protection and surveillance zone improve the surveillance
	// since first detection all farms improve their hygene
	// protection zone (3 km 40 days)
	// surveillance zone (10 km 30 days)
	
	// increased awareness
	
	
	// ~~~~~~~~Wild boar interventions
	// active surveillance for areas with detected animals (1 km radius)
	// after 1st detection, hunters sample 20% of the hunted animals
	
	
}

species Fence{
	bool is_active;
	
	// reflexes
	// Activate the fence
	reflex BecomeActive when: cycle > 10{
		is_active <- true;
		if HuntingPressure{
			ask Hx at_distance 1#km{
				if (S_wb + I_wb > (N_wb*0.1)){
					// Use R compartment to remove the 90% goal from the population
					local_gamma_wb <- Gamma_wb*HuntingPressureSpeed;
//					N_wb <- N_wb*HuntingEffect;
//				S_wb <- S_wb*HuntingEffect;
//				I_wb <- I_wb*HuntingEffect;
//				R_wb <- R_wb*HuntingEffect;	
				}
		}
			
		}
		
		// Reduce the wildboar movement between cells
		if Fencing and cycle = 10{
			ask Hx at_distance 1#km{
				p_Adj_Spread <- p_Adj_Spread * 0.1;
			}
		}
	}
	//~~~~~~~ Geometry:~~~~~~~~
	aspect geom{
		draw shape color: rgb(0, 0, 0, 0) border: is_active? #red:#grey;
	}
}
/* Insert your model definition here */

