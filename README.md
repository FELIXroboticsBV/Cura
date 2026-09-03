# FELIX FILO

Custom fork of the CURA slicer application to provide first class support for the FELIX printers. 

## Building from source 

Since you are here you probably want to build this application from source. If you are looking for installer take a [here]().

To build the application you have to follow steps from the Wiki of the official CURA repository. You can find the [instructions here](https://github.com/Ultimaker/Cura/wiki/Running-Cura-from-Source). 

The steps are exactly the same however when cloning the repository in step 2 make sure you clone this version of the application instead of the one provided in the guide. 

```bash
git clone https://github.com/FELIXroboticsBV/FELIX-FILO.git
cd FELIX-FILO
```

Once you are  finished with the steps open the project in PyCharm. And configure the virtual environment by visiting Settings->Interpreter->Add Interpreter->Add local interpreter

Here select and interpreter located in `Build/generator/cura_venv/` this will make sure all the dependencies installed in previous steps are available ! 

<p align="center">
<img width="400" height="200" alt="image" src="https://github.com/user-attachments/assets/98d995e2-0106-4ef0-a2bc-d28c72a89122" />
</p>


<p align="center">
<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/d4959de4-5427-42fa-8bdb-51259fd0b644" />
</p>
