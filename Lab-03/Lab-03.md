---
lab:
    title: '3: Migrating Hyper-V VMs to Azure by using Azure Migrate'
    module: 'Module 3: Design for Migration'
---

# Lab: Migrating Hyper-V VMs to Azure by using Azure Migrate
# Student lab manual

## Lab scenario

Despite its ambitions to modernize its workloads as part of migration to Azure, the Adatum Enterprise Architecture team realizes that, due to aggressive timelines, in many cases, it will be necessary to follow the lift-and-shift approach. To simplify this task, the Adatum Enterprise Architecture team started exploring the capabilities of Azure Migrate. Azure Migrate serves as a centralized hub to assess and migrate to Azure on-premises servers, infrastructure, applications, and data.

Azure Migrate provides the following features:

- Unified migration platform: A single portal to start, run, and track your migration to Azure.
- Range of tools: A range of tools for assessment and migration. Tools include Azure Migrate: Server Assessment and Azure Migrate: Server Migration. Azure Migrate integrates with other Azure services and with other tools and independent software vendor (ISV) offerings.
- Assessment and migration: In the Azure Migrate hub, you can assess and migrate:
- Servers: Assess on-premises servers and migrate them to Azure virtual machines.
- Databases: Assess on-premises databases and migrate them to Azure SQL Database or to SQL Managed Instance.
- Web applications: Assess on-premises web applications and migrate them to Azure App Service by using the Azure App Service Migration Assistant.
- Virtual desktops: Assess your on-premises virtual desktop infrastructure (VDI) and migrate it to Windows Virtual Desktop in Azure.
- Data: Migrate large amounts of data to Azure quickly and cost-effectively using Azure Data Box products.

While databases, web apps, and virtual desktops are in scope of the next stage of the migration initiative, Adatum Enterprise Architecture team wants to start by evaluating the use of Azure Migrate for migrating their on-premises Hyper-V virtual machines to Azure VM.

## Objectives

After completing this lab, you will be able to:

-  Prepare Hyper-V for migration by using Azure Migrate

-  Assess Hyper-V for migration by using Azure Migrate

-  Migrate Hyper-V VMs by using Azure Migrate

## Lab Environment

Windows Server admin credentials

-   User Name: **QA**

-   Password: **1q2w3e4r5t6y\***

Estimated Time: 60 minutes

### Exercise 0: Prepare the lab environment

The main tasks for this exercise are as follows:

1.  Deploy an Azure VM for the Lab

2.  Configure nested virtualization in the Azure VM

3.  Check the output

#### Task 1: Deploy an Azure VM for the Lab

1.  Open [**Cloud Shell**](https://shell.azure.com) pane by selecting on
    the toolbar icon directly to the right of the search textbox.

2.  If prompted, select **Bash** .

> **Note**: If this is the first time you are starting **Cloud Shell** and you are presented with the **You have no storage mounted** message, select the subscription you are using in this lab,  and select **Create storage**.

3.  In the toolbar of the Cloud Shell pane, run the following command to create the vm.

```sh
curl -O https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-03/Lab-03-Resources.bash
ls -la Lab-03-Resources.bash
chmod +x Lab-03-Resources.bash
./Lab-03-Resources.bash
```

#### Task 2: Configure nested virtualization in the Azure VM

1.  Select **Virtual machines** and, on the **Virtual machines** blade,
    select **Migrator**.

2.  Select **Networking**.

3.  Select **Connect**, in the drop-down menu, select **RDP**, and then
    click **Download RDP File**.

4.  When prompted, sign in with the following credentials:

-   User Name: **QA**

-   Password: **1q2w3e4r5t6y\***

> **Important Note:** All the actions you will follow including this step
    will be done on this Remote Computer's Console.

5.  Within the Remote Desktop session run the following command in
    **PowerShell** to create the guest vm to protect.
    
  ```powershell

  cd\
mkdir Lab03
$url = "https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-03/SetLab.ps1"
$output = "C:\Lab03\Lab03.ps1"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process Powershell.exe -Argumentlist "-file C:\Lab03\Lab03.ps1"
  ```
  
**This will take approximetaly 8-10 minutes may be a little more. When finished Hyper-V Console will appear.**

**Please Do not take any action until then**

6.  In the Hyper-V Console Click **Migrator**

7.  Double click **2012-R2** to open Virtual Machine Connection window.

8.  On the **License terms** page, select **United Kingdom** and click *Next* to **Accept**.

9.  Set the password of the built-in Administrator account
    to **London2020\*** and select **Finish**.

10.  After Restart, sign in by using the newly set password.

-   Note: Your Guest Vm will be restarted once more automatically and will be ready after this step.


#### Task 3: Check the output

1.  Go back to Azure portal and navigate to newly created Resource Group. Click the Traffic Manager **Lab-03-TM**
2.  On the overview page you will see 2 Endpoints. Ensure that Onprem is Online, and Migrated is Degraded.
       
    | Name | Status | Monitor Status |
    | --- | --- |--- |
    | Onprem | Enabled | **Online**|
    |Migrated | Enabled |**Degraded**|
    
2.  Copy the **DNS Name** and visit that URL on a new tab on your browser
3.  Ensure that the page welcomes you with the current date

> **Note:** If fails please ask for support, this will be needed for the next exercises.

> #### Result: We created a server hosting 2012-R2 VM. This vm is published to internet with its dns name and that name is behind a Traffic Manager. When a client visits the Traffic Manager URL, they will be diverted to use the 2012-R2 guest vm on the on-prem host.When the Lab completed, 2012-R2 VM will be migrated to Azure and Traffic Manager will show vise-versa, but the page will be still available.

### Exercise 1: Create and configure an Azure Site Recovery vault

The main tasks for this exercise are as follows:

1.  Create an Azure Site Recovery vault

2.  Configure the Azure Site Recovery vault

#### Task 1: Create an Azure Site Recovery vault

1.  Within the Remote Desktop session to **Migrator** (the host, not 2012R2), navigate to
    the [**Azure Portal**](https://portal.azure.com), and sign in.
    
2.  Click +New and search for **Backup and Site Recovery** and click **Create**

3.  On the **Create Recovery Services vault** blade, specify the
    following settings (leave others with their default values) and
    select **Review + create**:

    | Setting | Value |
    | --- | --- |
    | Subscription | the name of the Azure subscription you are using in this lab |
    | Resource group | a **new** Resource Group **Lab-03-Migrated** |
    | Vault name | **BCDR** |
    | Location | **East Us**  |

4.  On the **Review + create** tab of the **Create Recovery Services
    vault** blade, select **Create**:

> **Note**: By default, the default configuration for Storage
> Replication type is set to Geo-redundant (GRS) and Soft Delete is
> enabled. You will change these settings in the lab to simplify
> deprovisioning, but you should use them in your production
> environments.

#### Task 2: Configure the Azure Site Recovery vault

1.  Open the newly created *Recovery Services vault* **BCDR**.

2.  Select **Properties**.

3.  Select the **Update** link under the **Backup Configuration** label.

    -   Set **Storage replication type** to **Locally-redundant**, and
        select **Save** and close the **Backup Configuration** blade.

> **Note**: Storage replication type cannot be changed once you start
> protecting items.

4.  Select the **Update** link under the **Security Settings** label.

    -   Set **Soft Delete** to **Disable**, and select **Save** and
        close the **Security Settings** blade.

### Exercise 2: Implement Hyper-V protection by using Azure Site Recovery Vault

The main tasks for this exercise are as follows:

1.  Prepare Infrastructure

2.  Enable replication

3.  Review Azure VM replication settings

4.  Perform the Failover of the Hyper-V virtual machine

5.  Check the Migration


#### Task 1: Prepare Infrastructure

1.  Within the Remote Desktop Select Site Recovery **BCDR**, under
    **Site Recovery**, click **Getting Started**

2.  Under **Hyper-V Machines to Azure**, section, select **Prepare
    infrastructure**.

-   Note: Your instructor should explain the other options.

3. On the **Prepare infrastructure** blade, you will have 5 steps to
   follow

   1.  **Deployment Planning**
        - Choose **Yes, I have done it** and click **Next**
        
   
   2. **Source Settings**
        - Are you Using System Center VMM to manage Hyper-V hosts?
            - No
        - Add Hyper-V Site: **QA-London**
        - Hyper-V Servers:
          -  Click **Add Hyper-V Server**
      
                -   Click download the installer to download the installer on **Step 3**
                    -   If it does not start downloading right click "Download" and choose **Open Link in new Tab**
                    -   If it still does not start downloading, right click and choose "save as"
      
                -   Click the Big Blue **Download** Button to download the registration file

          - Launch the downloaded **AzureSiteRecoveryProvider.exe** file. This will start the installation wizard.
      
          - On the Microsoft Update page, select **Off** and select **Next**.
      
          - On the Provider installation page, select **Install**.

          - Click **Register** when the wizard asks. Select Browse, navigate to the **Downloads**, select the *vault credentials file*, and click **Open**. 
          
          - Complete the rest of the steps on the wizard with default selections.
          
          - Click **Finish** when the installation completes
          > **Note:** If your host, **Migrator** does not appear, click *Previous* and get back to step 3 by clicking *Next* and choose your Hyper-V Site from the drop down menu, your server will appear.
    
   3. **Target Settings**
         - This will choose the existing selected/default subscription and checks if you have a storage account and a Virtual Network at the location available. Leave with the default setting with default values. Click **Next**.
            >Note: You already have a storage account and a VNet. If you had not, you woul have the chance to create on this form.
    
   4. **Replication Policy**
         - **Create new policy and associate**. (Leave default settings, ensure you assign a **Name** and set initial Replication as **Immediately**)
         - Name: Provide a name e.g: **Rep-Pol**
           - Copy Frequency **5 Minutes**
           - Recovery point retention in hours **Default Values**
           - App-Consistent snapshot frequency in hours **Default Values**
           - Initial Replication start time: **Immediately**	
           - Click **Next** after completed	
            
     5. **Review**  
          * Click **Prepare**	
4. This will divert you back to **BCDR \| Site Recovery** blade. Else, navigate yourself.

#### Task 2: Enable replication

1.  Under **BCDR \| Site Recovery**, click **Getting Started**

2.  Under **Hyper-V Machines to Azure**, section, select **Enable
    replication**.

3. On the **Enable Replication** blade, you will have 6 steps to follow

   1. **Source Environment**

      - Choose **QA-London** and click Next
            

   2. **Target Environment**

      - **Subscription**
        - You can choose any subscription, alas under the same **Tenancy**

      - **Post-Failover Resource Group**
        - Choose the RG. **Lab-03-Migrated** for this exercise. This menu does not allow you to create a new RG. You can
              create on a different menu and refresh the page to see here.    
      - **Post-failover deployment model.**
        - Choose **Resource Manager**. This is the default setting
      - **Storage**
        - Choose the storage account ending with **mig01**
      - **Network**
        - Virtual Network: **Mig-VNet**
        - Subnet: **SN02**
      - Click **Next**

   3. **Virtual Machine Selection** 
    
        - Choose 2012-R2 and click **Next**

   4. **Replication Settings**
        - Choose OS Type as Windows. (this is for drivers for that OS) and click **Next**
         
   5. **Replication Policy**
        - Leave the default selected Replication Policy (this is the one we created the one with immediately) and click **Next** 
   
   6. **Review**
        - Review the settings and click **Enable Replication**
   
4.  This will take approximately 5-7 minutes. You can follow the steps
    by clicking notifications on the dark blue bar of azure portal.

5.  Good time to have a nice coffee break

6.  Also, you can follow the replication progress on Hyper-V console, by
    the status of the 2012-R2 virtual machine.

#### Task 3: Review Azure VM replication settings


1.  In the Azure portal, navigate to the **BCDR** blade, under
    Overview \| Site Recovery and select **Replicated items**.

2.  On **Replicated items** blade, ensure that 2012-R2 VM is listed
    as **Healthy** and that its **Status** is listed as either Enabling
    protection or **Protected.**

> **Note**: You will need to wait until status is listed as
> **Protected** before the next step. This might take additional 5 - 10
> minutes

3.  Select the **2012-R2** entry.

4.  Click **Compute and Network** and click **Edit.** Update the
    properties as below.

    -   Resource Group: **Lab-03-Migrated**

    -   Size: Standard **B2s** **(2 cores 4GB Memory, 3 NICs)**

    -   Virtual Network: **Mig-VNet**
    
    -   Azure Hybrid Benefit: **Yes,** and **Confirm**

5.  Click **Save**

6.  Click **Overview**

#### Task 4: Perform the Failover of the Hyper-V virtual machine

1.  Navigate back to the **BCDR.** Click **Replicated Items** and
    click **2012-R2** 

2.  Select **Planned failover**.

3.  On the **Planned failover** blade, Accept the warning and click **OK.**

4.  Follow the notifications until the failover completed.

5.  In the Azure portal, ensure that newly provisioned virtual
    machine **2012-R2** is listed.

7.  After Failover Completed. We will **Complete the Migration.** 

8.  To Complete the Migration, Click the **Complete Migration** button on the page Replicated Items, 2012-R2 and clik **OK**

> Note: This will complete the traffic and replication between the source and newly created VM.

#### Task 5: Check the Migration

1.  Navigate to newly created virtual Machine, **2012-R2**
2.  Click **Networking**
3.  Choose Network Interface. You will see a complex name.
4.  Click **IP Configurations**, click the *ip address*.
5.  Set Public Ip address by clicking **Associate**
6.  Choose Migrated-Pip and click **Save**
7.  After Completed. Navigate to the Traffic manager. **Lab-03-TM**
8.  Ensure that, this time the Endpoints are vice-versa. Migrated is online.
| Name | Status | Monitor Status |
    | --- | --- |--- |
    | Onprem | Enabled | **Degraded**|
    |Migrated | Enabled |**Online**|
    
9.  Visit the Traffic Manager URL, you will see the same page.

> **Optional:** You can RDP to the 2012-R2 Vm with the password you provided. UserName will be **Administrator** and change the file content under c:\inetpub\wwwroot\iistart.html, to see that it is exactly publiching the page from the migrated server.


### Exercise 3: Remove Azure resources deployed in the lab

The main tasks for this exercise are as follows:

1.  Remove Azure resources deployed in the lab

#### Task 1: Remove Azure resources deployed in the lab

1.  Navigate back to the **BCDR**

2.  Click **Site Recovery infrastructure**

3.  Navigate to **Hyper-V Hosts** and delete the **Hyper-V Host**

    -   If you can't find the option click the ellipses to find the
        delete option

4.  After deleted, Navigate to **Hyper-V Sites** and delete the Hyper-V
    Site **QA-London**

5.  From the Cloud Shell pane, run the following to list the resource
    group you created in this exercise:
    
6.  After both deleted, follow the steps below.

```sh
az group list --query "[?contains(name,'Lab-03')]".name --output tsv

```
> **Note**: Verify that the output contains only the resource group you
> created in this lab. This group will be deleted in this task.

6.  From the Cloud Shell pane, run the following to delete the resource
    group you created in this lab
```sh
az group list --query "[?contains(name,'Lab-03')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
```

> Note: The Remote Computer you have been using during this lab will be automatically deleted
