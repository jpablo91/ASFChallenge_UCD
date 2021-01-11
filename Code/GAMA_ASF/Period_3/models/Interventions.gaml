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
	// ======= Interventions for second period
	// culling of all pig herds in protection zones (not surveillance)
	// increasing the size of the active search area around infected wild boar 
	// Culling of pig herds located <3km around detected positive wb carcasses
	// Increase the size of the surveillance zone from 10 to 15 km (but still during 30 days)
	// Culling ofall herds that havetraded pigs with an infected farm less than 3 weeks before detection
	
	
	
	// ~~~~~~~~Wild boar interventions
	// active surveillance for areas with detected animals (1 km radius)
	// after 1st detection, hunters sample 20% of the hunted animals
	
	
	
	
}

species Fence{
	bool is_active;
	
	// reflexes
	// Activate the fence
	reflex BecomeActive when: cycle = 0{
		is_active <- true;
		if HuntingPressure{
			ask Hx at_distance 1#km{
//				if (S_wb + I_wb > (N_wb*0.1)){
					// Use R compartment to remove the 90% goal from the population
					local_gamma_wb <- Gamma_wb*HuntingPressureSpeed;
					u_wb <- 0.09/step;
					in_Fence <- true;
//				}
		}
			
		}
		
		// Reduce the wildboar movement between cells
		if Fencing and cycle > 0{
			ask Hx at_distance 1#km{
				p_Adj_Spread <- p_Adj_Spread/40; 
			}
		}
	}
	//~~~~~~~ Geometry:~~~~~~~~
	aspect geom{
		draw shape color: rgb(0, 0, 0, 0) border: is_active? #red:#grey;
	}
}
/* Insert your model definition here */

