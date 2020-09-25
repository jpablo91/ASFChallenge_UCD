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
/* Insert your model definition here */

