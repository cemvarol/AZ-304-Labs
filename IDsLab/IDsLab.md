## Instructions

### Exercise 0: Prepare the lab environment


#### Task 1: Deploy an Azure VM for the Lab
1.	Open Cloud Shell pane by selecting on the toolbar icon directly to the right of the search textbox.
2.	If prompted, select Bash .
Note: If this is the first time you are starting Cloud Shell and you are presented with the You have no storage mounted message, select the subscription you are using in this lab, and select Create storage.
3.	In the toolbar of the Cloud Shell pane, run the following command to create the vm.

   ```powershell
curl -O https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-03/Lab-03-Resources.bash
ls -la Lab-03-Resources.bash
chmod +x Lab-03-Resources.bash
./Lab-03-Resources.bash
   ```
