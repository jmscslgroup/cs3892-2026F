# Simulink Models

cs3892 et al.
Vanderbilt University
Author: Jonathan Sprinkle, Dan Work


These models include both pure simulation examples, as well as example models that will be used to generate output code for integration with Ros.

Models will be built throughout the term. Examples in class will typically be placed in specific folders, while examples distributed by the teaching team will have descriptive names and be placed either in the `simulink` folder, or in subfolders appropriate to their content.

## Naming conventions

- `subjectWithDetail.slx` - a standalone project that simulates an idea or subject
- `component_sim.slx` - a simulink simulation of some component, to explore its design parameters
- `controller_mv.slx` or `controllerMV.slx` or similar- a mult-vehicle simulatin of the specific controller, with standard lead vehicle and following vehicle inputs/outputs. This kind of Simulink model enables validation that the implementation *in simulink* is functionally correct. You can expand to as many vehicles as you like to create, just use the pattern defined.
- `controller.slx` the model that will be used to generate the `controller` ros node through code generation. This model is not simulated using Simulink, it is only used for code generation. It should define and use only the ros topics that are previously designed and approved.


## Naming conventions for your project's Simulink models
- `teamname.slx` - the simulink implementation of your project as a Ros model, ready to generate code
- `teamname_sim.slx` - simulation of the teamname controller, but with inputs from Simulink sources or bagfiles, not from ros topics. The `_sim` indicates that it is not the project model.
- `teamnameMV.slx` - a multi-vehicle simulation of the teamname controller. Create as many of these as you want, but ensure to confirm consistency if you are updating your model, to have the copy you expect in each simulation.


