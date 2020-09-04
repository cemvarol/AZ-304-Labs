---
lab:
    title: '4: Managing Azure AD Authentication and Authorization'
    module: 'Module 4: Design Authentication and Authorization'
---

# Lab: Managing Azure AD Authentication and Authorization
# Student lab manual

## Lab scenario

As part of its migration to Azure, Adatum Corporation needs to define its identity strategy. Adatum has a single domain Active Directory forest named adatum.com and owns the corresponding, publicly registered DNS domain. As the Adatum Enterprise Architecture team is exploring the option of transitioning some of the on-premises workloads to Azure, it intends to evaluate integration between its Active Directory Domain Services (AD DS) environment and the Azure Active Directory (Azure AD) tenant associated with the target Azure subscription as the core component of its longer-term authentication and authorization model.

The new model should facilitate single sign-on, along with per-application step-up authentication that leverages multi-factor authentication capabilities of Azure AD. To implement single sign-on, the Architecture team plans to deploy Azure AD Connect and configure it for password hash synchronization, resulting in matching user objects in both identity stores. Choosing the optimal authentication method is the first concern for organizations wanting to move to the cloud. Azure AD password hash synchronization is the simplest way to implement single sign-on authentication for on-premises users when accessing Azure AD-integrated resources. This method is also required by some premium Azure AD features, such as Identity Protection.

To implement step-up authentication, the Adatum Enterprise Architecture team intends to take advantage of Azure AD Conditional Access policies. Conditional Access policies support enforcement of multi-factor authentication depending on the type of application or resource being accessed. Conditional Access policies are enforced after the first-factor authentication has been completed. Conditional Access can be based on a wide range of factors, including:

- User or group membership. Policies can be targeted to specific users and groups giving administrators fine-grained control over access.
- IP Location information. Organizations can create trusted IP address ranges that can be used when making policy decisions. Administrators can specify entire countries/regions IP ranges to block or allow traffic from.
- Device. Users with devices of specific platforms or marked with a specific state can be used when enforcing Conditional Access policies.
- Application. Users attempting to access specific applications can trigger different Conditional Access policies.
- Real-time and calculated risk detection. Signals integration with Azure AD Identity Protection allows Conditional Access policies to identify risky sign-in behavior. Policies can then force users to perform password changes or multi-factor authentication to reduce their risk level or be blocked from access until an administrator takes manual action.
- Microsoft Cloud App Security (MCAS). Enables user application access and sessions to be monitored and controlled in real time, increasing visibility and control over access to and activities performed within your cloud environment.

To accomplish these objectives the Adatum Enterprise Architecture team intends to test integration of its Active Directory Domain Services (AD DS) forest with its Azure Active Directory (Azure AD) tenant and evaluate the conditional access functionality for its pilot users.

## Objectives

After completing this lab, you will be able to:

 - Deploy an Azure VM hosting an AD DS domain controller

 - Create and configure an Azure AD tenant

 - Integrate an AD DS forest with an Azure AD tenant


## Lab Environment

Windows Server admin credentials

-  User Name: **QA**

-  Password: **1q2w3e4r5t6y***

Estimated Time: 45 minutes

## Instructions

### Exercise 0: Prepare the lab environment

The main tasks for this exercise are as follows:

1. Create a Vm for a Domain Controller

1. Promote the Vm as your domain controller

1. Create Domain Accounts


#### Task 1: Create a Vm for a Domain Controller

1. Navigate to the [Azure portal](https://portal.azure.com), and  [Azure Shell](https://shell.azure.com)   sign in by your credentials.

1. In the **Cloud Shell**, select  **Bash** , run the command below to create a new vm for this exercise

    ```powershell
    curl -O https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-04/Lab-04-Resources.bash
    ls -la Lab-04-Resources.bash
    chmod +x Lab-04-Resources.bash
    ./Lab-04-Resources.bash
    ```
      > **Note**: Wait until the vm is created. This will take 4-6 minutes.



#### Task 2: Promote the Vm as your domain controller

1.  Select **Virtual machines** and, on the **Virtual machines** blade,
    select **US-DC01**.

2.  Select **Networking**.

3.  Select **Connect**, in the drop-down menu, select **RDP**, and then
    click **Download RDP File**.

4.  When prompted, sign in with the following credentials:

    | Setting | Value |
    | --- | --- |
    | User Name | **QA** |
    | Password | **1q2w3e4r5t6y*** |

> **Important Note:** All the actions you will follow including this step
    will be done on this Remote Computer's Console.

5.  Within the Remote Desktop session run the following command in
    **PowerShell** to create the guest vm to protect.
    
  ```powershell

  cd\
mkdir Lab04
$url = "https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-04/Set-Lab.ps1"
$output = "C:\Lab04\Set-Lab.ps1"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process Powershell.exe -Argumentlist "-file C:\Lab04\Set-Lab.ps1"
  ```
> **Note**: After this script is run, the VM will be restarted automatically. You will need to re-connect to this vm on the next Task.

#### Task 3: Create Local Domain Accounts

1. Please connect to the same VM again. You can follow the steps 1-4 of Task 2.

1. On the desktop of your profile, right click the Create AD Users.ps1 file and choose **Run with Powershell**
1. Accept by typing A and hit Enter if any Powershell Policy is asked.
1. Script will ask for **How many users to create** Provide 50 as the number of users to create, and hit Enter. 
1. Observe the created users and groups in Local Domain.
> **Note**: This will create 50 users. They will be under OUs, and set for their group memberships. Observe the created users on Active Directory users and Computers. this will also create a user name **OnPremAdmin**

### Exercise 1: Configure an Azure AD tenant

The main tasks for this exercise are as follows:

1. Activate and assign Azure AD Premium P2 licensing

1. Create and configure Azure AD users


#### Task 1: Activate and assign Azure AD Premium P2 licensing

1. Back in the browser window displaying the Azure portal, navigate to the **Overview** blade of the **Adatum Lab** Azure AD tenant and, in the **Manage** section, select **Licenses**.

1. On the **Licenses | Overview** blade, select **All products**, select **+ Try/Buy**.

1. On the **Activate** blade, in the **Azure AD Premium P2** section, select **Free trial** and then select **Activate**. 

1. On the **Activate** blade, in the  **ENTERPRISE MOBILITY + SECURITY E5** section, select **Free trial** and then select **Activate**. 


#### Task 2: Create and configure Azure AD users

1. On the **Azure Active Directory**

1. Navigate to the **Users - All users** blade, and then select **+ New user**.

1. On the **New user** blade, create user with the following settings (leave others with their defaults):

    | Setting | Value |
    | --- | --- |
    | User name | **Superman** |
    | Name | **Clark Kent** |
    | Auto-generate password | enabled |
    | Show password | enabled |
    | Roles | **Global administrator** |
    | Usage location | **United States** |

    >**Note**: Record the full user name (including the domain name) and the auto-generated password. You will need it later in this task.

1. Open an **InCognito** browser window and sign in to the [Azure portal](https://portal.azure.com) using the newly created user account. When prompted to update the password, change the password to **1q2w3e4r5t6y*** 


### Exercise 2: Integrate AD DS forest with an Azure AD tenant

The main tasks for this exercise are as follows:

1. Assign a custom domain name to the Azur AD tenant

1. Configure AD DS in the Azure VM

1. Install Azure AD Connect

1. Configure properties of synchronized user accounts


#### Task 1: Assign a custom domain name to the Azur AD tenant

1.  On the **Azure Active Directory**

1. Select **Custom domain names**.

1. Identify the primary, default DNS domain name associated with the Azure AD tenant. 

    >**Note**: Record the value of the primary DNS name of the Azure AD tenant. You will need it in the next task.

1. Select **+ Add custom domain**.

1. Type **adatum.com**, and select **Add domain**. 

1. On the **adatum.com** blade, review the information necessary to perform verification of the Azure AD domain name and close the blade.

    > **Note**: You will not be able to complete the validation process because you do not own the **adatum.com** DNS domain name. This will *not* prevent you from synchronizing the **adatum.com** Active Directory domain with the Azure AD tenant. You will use for this purpose the default primary DNS name of the Azure AD tenant (the name ending with the **onmicrosoft.com** suffix), which you identified earlier in this task. However, keep in mind that, as a result, the DNS domain name of the Active Directory domain and the DNS name of the Azure AD tenant will differ. This means that Adatum users will need to use different names when signing in to the Active Directory domain and when signing in to Azure AD tenant.
   
   > **Note**: As explained earlier, this is expected, since you could not verify the custom Azure AD DNS domain **adatum.com**.

#### Task 2:  Install Azure AD Connect

1.Within the Remote Desktop session to **US-DC01**, Navigate to [Azure portal](https://portal.azure.com), select **Azure Active Directory** and click **Azure AD Connect**.

1. Select the **Download Azure AD Connect** link. You will be redirected to the **Microsoft Azure Active Directory Connect** download page, select **Download**.

1. After downloaded, **Run** to start the installation for **Microsoft Azure Active Directory Connect**.

1. On the first page of the **Microsoft Azure Active Directory Connect** wizard, select the checkbox **I agree to the license terms and privacy notice** and select **Continue**.

1. On the *Express Settings* step Choose **Use Express Settings**.

1. On the **Connect to AZure AD** step, provide the login information of newly created AzAD account and click **Next**. (superman) *This is an account has the Global Administrator Role*

1. On the **Connect to ADDS** page, provide the login information of *Enterprise Administrator* account **AURIAN\OnPremAdmin** with password *London2020** *This account is created by the script*

    | Setting | Value |
    | --- | --- |
    | User Name | **AURIAN\OnPremAdmin** |
    | Password | *London2020** |
    
1. On the **Azure AD sign-in configuration** page, note the warning stating **Users will not be able to sign-in to Azure AD with on-premises credentials if the UPN suffix does not match a verified domain name**, enable the checkbox **Continue without matching all UPN suffixes to verified domain**, and select **Next**.
    
1. On the **Ready to configure** page, **UNCHECK** the **Start the synchronization process when configuration completes** checkbox is selected and select **Install**.

    > **Note**: Installation should take about 2-4 minutes.
    
1. **Configuration Complete** step, click **Exit** to complete the installation.

1. Navigate to Azure Active Directory, click Users, ensure that the new account with the name **On-Premises Directory Synchronization Service Account** is created.

#### Task 3:  Configure Azure AD Connect

1. Double-Click the **Azure Ad Connect** to configure the settings of Azure AD Connect.

1. On the **Welcome to Azure AD Connect** step, click **Configure**

1. On the **Additional Taks** step, choose **Customize Synchronization Options**, and click **Next**

**User sign-in** page, ensure that only the **Password Hash Synchronization** is enabled and select **Next**.

1. On the **Connect to Azure AD** page, authenticate by using the credentials of the **az30310-aaduser1** user account you created in the previous exercise and select **Next**. 

1. On the **Connect to AZure AD** step, provide the password of Azure AD account and click **Next**. (superman) 

1. On the **Connect your directories** step, click **Next**.

1. On the **Domain and OU Filtering** step, choose **Sync Selected Domains and OUs**. Expand the aurian.club domain and uncheck the box next to domain name to clear all the boxes. 

1. Under *Sync Selected Domains and OUs* 
    - Choose either Tens or Twenties. (This proves that you can choose nested level of OUs to sync to Azure AD.
    - Choose any other OUs, e.g. Thirties, Forties etc.
    - Choose Groups

1. Click **Next**

1. On the **Optional Features** step, check **Password Writeback** and click **Next**

1. On the **Ready to Configure** step, CHECK the box for **Start the synchronization process when configuration completes** and click **Configure**

# DENYO



is selected, specify the following credentials, and select **OK**:

    
1. Back on the **Connect your directories** page, ensure that the **adatum.com** entry appears as a configured directory and select **Next**



 

1. On the **Domain and OU filtering** page, select the option **Sync selected domains and OUs**, clear all checkboxes, select only the checkbox next to the **ToSync** OU, and select **Next**.

1. On the **Uniquely identifying your users** page, accept the default settings, and select **Next**.

1. On the **Filter users and devices** page, accept the default settings, and select **Next**.

1. On the **Optional features** page, accept the default settings, and select **Next**.

1. On the **Ready to configure** page, ensure that the **Start the synchronization process when configuration completes** checkbox is selected and select **Install**.

    > **Note**: Installation should take about 2 minutes.

1. Review the information on the **Configuration complete** page and select **Exit** to close the **Microsoft Azure Active Directory Connect** window.


#### Task 4: Configure properties of synchronized user accounts

1. Within the Remote Desktop session to **az30310a-vm1**, in the Internet Explorer window displaying the Azure portal, navigate to the **Users - All users** blade of the Adatum Lab Azure AD tenant.

1. On the **Users | All users** blade, note that the list of user objects includes the **aduser1** account, with the **Windows Server AD** appearing in the **Source** column.

    > **Note**: You might have to wait a few minutes and select **Refresh** for the **aduser1** user account to appear.

1. On the **Users | All users** blade, select the **aduser1** entry.

1. On the **aduser1 | Profile** blade, note the full name of the user account.

    > **Note**: Record the full user name. You will need it in the next exercise.

1. On the **aduser1 | Profile** blade, in the **Job info** section, note that the **Department** attribute is not set.

1. Within the Remote Desktop session to **az30310a-vm1**, switch to **Active Directory Administrative Center**, select the **aduser1** entry in the list of objects in the **ToSync** OU, and, in the **Tasks** pane, in the **ToSync** section, select **Properties**.

1. In the **aduser1** window, in the **Organization** section, in the **Department** text box, type **Sales**, and select **OK**.

1. Within the Remote Desktop session to **az30310a-vm1**, start **Windows PowerShell**.

1. From the **Administrator: Windows PowerShell** console, run the following to start Azure AD Connect delta synchronization:

   ```powershell
   Import-Module -Name 'C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1'

   Start-ADSyncSyncCycle -PolicyType Delta
   ```

1. Switch to the Internet Explorer window displaying the **aduser1 | Profile** blade, refresh the page and note that the **Department** property is set to **Sales**.

    > **Note**: You might need to wait for another minute and refresh the page again if the **Department** attribute remains not set.

1. On the **aduser1 | Profile** blade, select **Edit**.

1. On the **aduser1 | Profile** blade, in the **Settings** section, in the **Usage location** drop-down list, select **United States** and then select **Save**.

1. On the **aduser1 | Profile** blade, select **Licenses**.

1. On the **aduser1 | Licenses** blade, select **+ Assignments**.

1. On the **Update license assignments** blade, select the **Azure Active Directory Premium P2** checkbox and select **Save**.


### Exercise 3: Implement Azure AD conditional access

The main tasks for this exercise are as follows:

1. Disable Azure AD security defaults.

1. Create an Azure AD conditional access policy

1. Verify Azure AD conditional access

1. Remove Azure resources deployed in the lab


#### Task 1: Disable Azure AD security defaults.

1. Within the Remote Desktop session to **az30310a-vm1**, in the Internet Explorer window displaying the Azure portal, navigate to the **Adatum Lab | Overview** blade of the Adatum Lab Azure AD tenant.

1. On the **Adatum Lab | Overview** blade, in the **Manage** section, select **Properties**.

1. On the **Adatum Lab | Properties** blade, select the **Manage Security defaults** link at the bottom of the page.

1. On the **Enable Security defaults** blade, set **Enable Security defaults** switch to **No**, select the checkbox **My organization is using Conditional Access**, and select **Save**. 


#### Task 2: Create an Azure AD conditional access policy

1. On the **Adatum Lab | Properties** blade, in the **Manage** section, select the **Security**.

1. On the **Security | Getting started** blade, select **Conditional Access**.

1. On the **Conditional Access | Policies** blade, select **+ New policy**.

1. On the **New** blade, in the **Name** text box, type **Azure portal MFA enforcement**. 

1. On the **New** blade, in the **Assignments** section, select **Users and groups**, on the **Include** tab, select **Select users and groups**, select the **Users and groups** checkbox, on the **Select** blade, select **aduser1**, and confirm your choice by clicking **Select**.

1. Back on the **New** blade, in the **Assignments** section, select **Cloud apps or actions**, on the **Include** tab, select **Select apps**, click **Select**, on the **Select** blade, select **Microsoft Azure Management** checkbox, and confirm your choice by clicking **Select**.

1. Back on the **New** blade, in the **Access controls** section, select **Grant**, on the **Grant** blade, ensure that the **Grant** option is selected, select **Require multi-factor authentication**, and confirm your choice by clicking **Select**.

1. Back on the **New** blade, set the **Enable policy** switch to **On** and select **Create**.


#### Task 3: Verify Azure AD conditional access

1. Within the Remote Desktop session to **az30310a-vm1**, start a new **InPrivate Browsing** Internet Explorer window and navigate to the Access Panel Applications portal [https://account.activedirectory.windowsazure.com](https://account.activedirectory.windowsazure.com).

1. When prompted, sign in by using the synchronized Azure AD account of the **aduser1**, using the full user name you recorded in the previous exercise and the **Pa55w.rd1234** password. 

1. Verify that you can successfully sign in to the Access Panel Applications portal. 

1. In the same browser window, navigate to the [Azure portal](https://portal.azure.com).

1. Note that, this time, you are presented with the message **More information required**. Within the page displaying the message, select **Next**. 

1. At that point, you will be redirected to the **Additional security verification** page, which will step you through configuring multi-factor authentication.

    > **Note**: Completing the multi-factor authentication configuration is optional. If you proceed, you will need to designate your mobile device as an authentication phone or to use it to run a mobile app.


#### Task 4: Remove Azure resources deployed in the lab

1. Within the Remote Desktop session to **az30310a-vm1**, start Internet Explorer and browse to the Microsoft Online Services Sign-In Assistant for IT Professionals RTW at [https://go.microsoft.com/fwlink/p/?LinkId=286152](https://go.microsoft.com/fwlink/p/?LinkId=286152). 

1. On the Microsoft Online Services Sign-In Assistant for IT Professionals RTW download page, select **Download**, on the **Choose the download you want** page, select **en\msoidcli_64.msi**, and select **Next**. 

1. When prompted, run **Microsoft Online Services Sign-in Assistant Setup** with the default options.

1. Once the setup completes, within the Remote Desktop session to **az30310a-vm1**, start **Windows PowerShell** console.

1. In the **Administrator: Windows PowerShell** window, run the following to install the required PowerShell module:

   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
   Install-Module MSOnline -Force
   ```
1. In the **Administrator: Windows PowerShell** window, run the following to authenticate to the **Adatum Lab** Azure AD tenant:

   ```powershell
   Connect-MsolService
   ```

1. When prompted to authenticate, provide the credentials of the **az30310-aaduser1** user account.

1. In the **Administrator: Windows PowerShell** window, run the following to disable Azure AD Connect synchronization:

   ```powershell
   Set-MsolDirSyncEnabled -EnableDirSync $false -Force
   ```

1. From the lab computer, in the browser window displaying the Azure portal, navigate to the **Azure Active Directory Premium P2 - Licensed users** blade, select the user accounts to which you assigned licenses in this lab, select **Remove license**, and, when prompted to confirm, select **OK**.

1. In the Azure portal, navigate to the **Users - All users** blade and ensure that all user accounts you created in this lab have the **Azure Active Directory** entry in the **Source** column. 

    > **Note**: If that's not the case, refresh the browser page.

1. On the **Users - All users** blade, select each user accounts you created in this lab and select **Delete** in the toolbar. 

1. Navigate to the **Adatum Lab - Overview** blade of the Adatum Lab Azure AD tenant, select **Delete tenant**, on the **Delete directory 'Adatum Lab'** blade, select the **Get permission to delete Azure resources** link, on the **Properties** blade of Azure Active Directory, set **Access management for Azure resources** to **Yes** and select **Save**.

1. Sign out from the Azure portal and sign in back. 

1. Navigate back to the **Delete directory 'Adatum Lab'** blade and select **Delete**.

1. Within the Remote Desktop session to **az30310a-vm1**, in the browser window displaying the Azure portal, start a PowerShell session within the Cloud Shell pane.

1. From the Cloud Shell pane, run the following to list the resource group you created in this exercise:

   ```powershell
   Get-AzResourceGroup -Name 'az30310*'
   ```

    > **Note**: Verify that the output contains only the resource group you created in this lab. This group will be deleted in this task.

1. From the Cloud Shell pane, run the following to delete the resource group you created in this lab

   ```powershell
   Get-AzResourceGroup -Name 'az30310*' | Remove-AzResourceGroup -Force -AsJob
   ```

1. Close the Cloud Shell pane.
