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

#### Task 2: Assign Managed Identity

Run the command below to assign the Mid to the new VM

```sh
az vm identity assign --resource-group IDLab1 --name IDs-VM01 --identities mid01
```

#### Task 3: Assign Roles to Managed Identity

1.	In the Azure portal, assign reader role to mid01 on IDLab1
2.	In the Azure portal, assign owner role to mid01 on IDLab2


### Exercise 2: Use the assigned Managed Identity


#### Task 1: Connect to the Virtual Machine

1.  Select **Virtual machines** and, on the **Virtual machines** blade,
    select **IDs-VM0**.

2.  Select **Networking**.

3.  Select **Connect**, in the drop-down menu, select **RDP**, and then
    click **Download RDP File**.

4.  When prompted, sign in with the following credentials:

-   User Name: **QA**

-   Password: **1q2w3e4r5t6y\***


#### Task 2: Prepare the Virtual Machine for Managed Identity
   >**Note:** This is a Core Operating system. You will only see command prompt window. Type powershell on the command prompt to start the powershell session.

