## Instructions

### Exercise 0: Prepare the lab environment


#### Task 1: Deploy an Azure VM for the Lab
1. Navigate to the [Azure portal](https://portal.azure.com), and  [Azure Shell](https://shell.azure.com)   sign in by your credentials.
1. In the **Cloud Shell**, select  **Bash** , run the command below to create a new vm for this exercise
3.	In the toolbar of the Cloud Shell pane, run the following command to create the vm.


      ```sh
      curl -O https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/IDsLab/IDsLab-Resources.bash
      ls -la IDsLab-Resources.bash
      chmod +x IDsLab-Resources.bash
      ./IDsLab-Resources.bash
      ```
      
### Exercise 1: Create and Assign Managed Identity       
      
#### Task 1: Create the Managed Identity

Run the command below to create Managed Identity

```sh
az identity create --resource-group IDLab1 --name mid01
```
