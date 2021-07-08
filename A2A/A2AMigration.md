# Evaluating and Performing Server Migration to Azure

# Lab: Implementing Azure to Azure migration

### Scenario

Adatum Corporation wants to migrate their existing Azure VMs to another region

### Objectives

After completing this lab, you will be able to:

- Implement Azure Site Recovery Vault

- Migrate Azure VMs between Azure regions

### Lab Setup

Estimated Time: 45 minutes

## Exercise 1: Implement prerequisites for migration of Azure VMs by using Azure Site Recovery

The main tasks for this exercise are as follows:

1. Deploy an Azure VM to be migrated

1. Create an Azure Recovery Services vault

#### Task 1: Deploy an Azure VM to be migrated

1. From the lab virtual machine, start Microsoft Edge and browse to the Azure portal at [**http://portal.azure.com**](http://portal.azure.com) and sign in by using the Microsoft account that has the Owner role in the target Azure subscription.

1. In the Azure portal, in the Microsoft Edge window, start a **Bash** session within the **Cloud Shell**.

1. If you are presented with the **You have no storage mounted** message, click create storage:

1. From the Cloud Shell pane, create a resource group by running the script below. This will create a VM with Server 2019 Operating System in Azure West Europe region to Migrate to another Azure Region. 

   ```sh
   curl -O https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/A2A/CreateResources.bash
   ls -la CreateResources.bash
   chmod +x CreateResources.bash
   ./CreateResources.bash
   ```



#### Task 2: Implement an Azure Recovery Service vault

1. From Azure Portal, create an instance of **Recovery Services vault** with the following settings:

   - Name: **BCDRA2A**

   - Subscription: the name of the target Azure subscription

   - Resource group: Create a new Resource Group  **BCDRA2A-RG**

   - Location: the name of an Azure region that is available in your subscription and which is **DIFFERENT** from the region you deployed an Azure VM in the previous task. (Means not West Europe, which your VM is now at.)

1. Wait until the vault is provisioned. This will take about a minute.

> **Result**: After you completed this exercise, you have created an Azure VM to be migrated and an Azure Site Recovery vault that will host the migrated disk files of the Azure VM.

## Exercise 2: Migrate an Azure VM between Azure regions by using Azure Site Recovery

The main tasks for this exercise are as follows:

1. Configure Azure VM replication

1. Review Azure VM replication settings

1. Disable replication of an Azure VM and delete the Azure Recovery Services vault

#### Task 1: Configure Azure VM replication

1. In the the Azure portal, navigate to the blade of the newly provisioned Azure Recovery Services vault.

1. On the Recovery Services vault blade, click the **+ Replicate** button.

1. Enable replication by specifying the following settings:

   - Source: **Azure**

   - Source location: the same Azure region into which you deployed the Azure VM in the previous exercise of this lab

   - Azure virtual machine deployment model: **Resource Manager**

   - Source resource group: **MigrateA2A**

   - Virtual machines: **VM01**

   - Target location: the name of an Azure region that is available in your subscription and which is different from the region you deployed an Azure VM in the previous task

   - Target resource group: **(new) MigrateA2A-asr**

   - Target virtual network: **(new) A2A-VNet-asr**

   - Cache storage account: accept the default setting

   - Replica managed disks: **(new) 1 premium disk(s), 0 standard disk(s)**

   - Target availability sets: **Not Applicable**

   - Replication policy: **Create new**

   - Name: **12-hour-retention-policy**

   - Recovery point retention: **12 Hours**

   - App consistent snapshot frequency: **6 Hours**

   - Multi-VM consistency: **No**

1. Initiate creation of target resources.

1. Enable the replication.

   > **Note**: Wait for the operation of enabling the replication to complete. Then proceed to the next task.

#### Task 2: Review Azure VM replication settings

1. In the Azure portal, from the Azure Site Recovery vault blade, navigate to the replicated item blade representing the Azure VM **VM01**.

2. On the replicated item blade, review the **Health and status**, **Latest available recovery points**, and **Failover readiness** sections. Note the **Failover** and **Test Failover** entries in the toolbar. Scroll down to the **Infrastructure view**.

3. If time permits, wait until the status of the Azure VM changes to **Protected**. This might take additional 15-20 minutes. At that point, examine the values **Crash-consistent** and **App-consistent** recovery points. In order to view **RPO**, you should perform a test failover.

#### Task 3: Disable replication of an Azure VM and delete the Azure Recovery Services vault

1. In the Azure portal, disable replication of the Azure VM **VM01**.

2. Wait until the replication is disabled.

3. From the Azure portal, delete the Recovery Services vault.

   > **Note**: You must ensure that the replicated item is removed first before you can delete the vault.

> **Result**: After you completed this exercise, you have implemented automatic replication of an Azure VM.

## Exercise 3: Remove lab resources

#### Task 1: Open Cloud Shell

1. At the top of the portal, click the **Cloud Shell** icon to open the Cloud Shell pane.

1. If needed, switch to the **Bash** shell session by using the drop down list in the upper left corner of the Cloud Shell pane.

1. At the **Cloud Shell** command prompt, type in the following command and press **Enter** to list all resource groups you created in this lab:

   ```sh
   az group list --query "[?starts_with(name,'A2A')].name" --output tsv
   ```

1. Verify that the output contains only the resource groups you created in this lab. These groups will be deleted in the next task.

#### Task 2: Delete resource groups

1. At the **Cloud Shell** command prompt, type in the following command and press **Enter** to delete the resource groups you created in this lab

   ```sh
   az group list --query "[?starts_with(name,'A2A')].name" --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
   ```

1. Close the **Cloud Shell** prompt at the bottom of the portal.

> **Result**: In this exercise, you removed the resources used in this lab.
