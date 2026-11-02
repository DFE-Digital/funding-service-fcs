namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.UI
{
    using System;
    using System.Linq;
    using DTO.ContractTermination;
    using OpenQA.Selenium;
    using OpenQA.Selenium.Support.UI;

    public class UpdateContractTerminationDialog
    {
        private readonly CrmWebDriver _driver;

        private UpdateContractTerminationDialog(CrmWebDriver driver)
        {
            _driver = driver;
        }

        public static UpdateContractTerminationDialog Create(CrmWebDriver driver, Guid contractId)
        {
            driver.NavigateTo($@"main.aspx?etn=sfa_contract&pagetype=entityrecord&id={contractId:D}");

            IWebElement popoutIntoNewTabWithMenuItemsButton = driver.WaitForElement(By.Id("popoutButton"));
            popoutIntoNewTabWithMenuItemsButton.Click();
            driver.SwitchToPopupWindow();

            IWebElement terminationMenuLink = driver.WaitForElement(By.XPath("//a[@class='ms-crm-Menu-Label']//span[contains(text(),'Termination')]"));
            terminationMenuLink.Click();
            driver.SwitchToPopupWindow(windowNumber: 3);

            IWebElement updateTerminationDetailsRadioButton = driver.WaitForElement(By.XPath("//label[text()='Select action to be performed']/following::input[@type='radio' and @value='0']"));
            updateTerminationDetailsRadioButton.Click();

            driver.WaitForElement(By.Id("butNext")).Click();
            
            return new UpdateContractTerminationDialog(driver);
        }

        public string UpdateTerminationDetails(UpdateContractTerminationRequest updateTerminationRequest)
        {
            const string validationErrorPrefix = "Unable to";
            const string validationNotificationLabelXPath = "//tr[@id='1row']//label[@class='PromptText']";

            IWebElement contractTerminationDateInput = _driver.WaitForElement(By.XPath("//label[text()='Contract Termination Date']/following::input[@type='text']"));
            contractTerminationDateInput.Clear();
            if (updateTerminationRequest.ContractTerminationDate.HasValue)
            {
                contractTerminationDateInput.SendKeys(updateTerminationRequest.ContractTerminationDate.Value.ToString("dd/MM/yyyy"));
            }

            if (updateTerminationRequest.TerminationReason != null)
            {
                SelectElement terminationReasonSelect = new SelectElement(_driver.WaitForElement(By.XPath("//label[starts-with(text(), 'Termination Reason')]/following::select")));
                terminationReasonSelect.SelectByText(updateTerminationRequest.TerminationReason);
            }

            IWebElement terminationCommentsTextarea = _driver.WaitForElement(By.XPath("//label[text()='Termination Comments']/following::textarea"));
            terminationCommentsTextarea.Clear();
            if (updateTerminationRequest.TerminationComments != null)
            {
                terminationCommentsTextarea.SendKeys(updateTerminationRequest.TerminationComments);
            }

            // move to the allocation page of the wizard
            _driver.WaitForElement(By.Id("butNext")).Click();

            IWebElement notificationLabel = _driver.WaitForElement(By.XPath(validationNotificationLabelXPath));

            if (notificationLabel.Text.Contains(validationErrorPrefix))
            {
                return notificationLabel.Text; // failed CVR contract validation rules
            }

            if (notificationLabel.Text.Contains("Please Click Next to correct the allocation level validation issues"))
            {
                // move beyond invalid existing allocation termination details warning to the allocation-editing page of the wizard
                _driver.WaitForElement(By.Id("butNext")).Click();
            }

            foreach (UpdateContractTerminationRequest.UpdateAllocationTerminationRequest allocation in updateTerminationRequest.Allocations)
            {
                UpdateAllocationTerminationDetails(allocation.AllocationNumber, allocation.AllocationStopNewStartsDate, allocation.AllocationTerminationDate);

                notificationLabel = _driver.WaitForElement(By.XPath(validationNotificationLabelXPath));

                if (notificationLabel.Text.Contains(validationErrorPrefix))
                {
                    return notificationLabel.Text; // failed CAVR allocation validation rules
                }
            }

            // move to the final page of the wizard
            _driver.WaitForElement(By.Id("butNext")).Click();

            // wait for the last wizard page to load before checking for final validation errors
            _driver.WaitForElement(By.Id("butFinish"));

            if (_driver.HasElement(By.XPath(validationNotificationLabelXPath)))
            {
                notificationLabel = _driver.FindElement(By.XPath(validationNotificationLabelXPath));

                if (notificationLabel.Text.Contains(validationErrorPrefix))
                {
                    return notificationLabel.Text; // failed CAFV final validation rules
                }
            }

            _driver.FindElement(By.Id("butFinish")).Click();

            return string.Empty; // no errors
        }

        private void UpdateAllocationTerminationDetails(string allocationNumber, DateTime? allocationStopNewStartsDate, DateTime? allocationTerminationDate)
        {
            IWebElement modifyIndividualAllocationsYesRadioButton =_driver.WaitForElement(By.XPath("//label[starts-with(text(),'To modify the dates')]/following::input[@type='radio' and @value='1']"));
            modifyIndividualAllocationsYesRadioButton.Click();

            SelectElement allocationNumberSelect = new SelectElement(_driver.WaitForElement(By.XPath("//label[text()='Contract Allocation to modify']/following::select")));
            IWebElement desiredOption = allocationNumberSelect.Options.Single(o => o.Text.Contains(allocationNumber));
            allocationNumberSelect.SelectByIndex(allocationNumberSelect.Options.IndexOf(desiredOption));

            _driver.WaitForElement(By.Id("butNext")).Click();

            IWebElement allocationStopNewStartsDateInput = _driver.WaitForElement(By.XPath("//label[text()='Contract Allocation Stop New Starts Date']/following::input[@type='text']"));
            allocationStopNewStartsDateInput.Clear();
            if (allocationStopNewStartsDate.HasValue)
            {
                allocationStopNewStartsDateInput.SendKeys(allocationStopNewStartsDate.Value.ToString("dd/MM/yyyy"));
            }

            IWebElement allocationTerminationDateInput = _driver.WaitForElement(By.XPath("//label[text()='Contract Allocation Termination Date']/following::input[@type='text']"));
            allocationTerminationDateInput.Clear();
            if (allocationTerminationDate.HasValue)
            {
                allocationTerminationDateInput.SendKeys(allocationTerminationDate.Value.ToString("dd/MM/yyyy"));
            }

            _driver.WaitForElement(By.Id("butNext")).Click();
        }
    }
}
