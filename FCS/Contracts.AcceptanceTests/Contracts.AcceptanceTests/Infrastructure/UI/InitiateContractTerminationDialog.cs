namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.UI
{
    using System;
    using System.Linq;
    using DTO.ContractTermination;
    using OpenQA.Selenium;
    using OpenQA.Selenium.Support.UI;

    public class InitiateContractTerminationDialog
    {
        private readonly CrmWebDriver _driver;

        private InitiateContractTerminationDialog(CrmWebDriver driver)
        {
            _driver = driver;
        }

        public static InitiateContractTerminationDialog Create(CrmWebDriver driver, Guid contractId)
        {
            driver.NavigateTo($@"main.aspx?etn=sfa_contract&pagetype=entityrecord&id={contractId:D}");

            IWebElement popoutIntoNewTabWithMenuItemsButton = driver.WaitForElement(By.Id("popoutButton"));
            popoutIntoNewTabWithMenuItemsButton.Click();
            driver.SwitchToPopupWindow();

            IWebElement terminationMenuLink = driver.WaitForElement(By.XPath("//a[@class='ms-crm-Menu-Label']//span[contains(text(),'Termination')]"));
            terminationMenuLink.Click();
            driver.SwitchToPopupWindow(windowNumber: 3);

            return new InitiateContractTerminationDialog(driver);
        }

        public string TerminateContract(ContractTerminationRequest terminationRequest)
        {
            const string validationErrorPrefix = "Unable to";
            const string validationNotificationLabelXPath = "//tr[@id='1row']//label[@class='PromptText']";

            if (terminationRequest.DefaultStopNewStartsDate.HasValue)
            {
                IWebElement defaultStopNewStartsDateInput = _driver.WaitForElement(By.XPath("//label[text()='Default Stop New Starts Date']/following::input[@type='text']"));
                defaultStopNewStartsDateInput.SendKeys(terminationRequest.DefaultStopNewStartsDate.Value.ToString("dd/MM/yyyy"));
            }

            if (terminationRequest.ContractTerminationDate.HasValue)
            {
                IWebElement contractTerminationDateInput = _driver.WaitForElement(By.XPath("//label[text()='Contract Termination Date']/following::input[@type='text']"));
                contractTerminationDateInput.SendKeys(terminationRequest.ContractTerminationDate.Value.ToString("dd/MM/yyyy"));
            }

            if (terminationRequest.TerminationReason != null)
            {
                SelectElement terminationReasonSelect = new SelectElement(_driver.WaitForElement(By.XPath("//label[text()='Termination Reason']/following::select")));
                terminationReasonSelect.SelectByText(terminationRequest.TerminationReason);
            }

            if (terminationRequest.InitiateAmendmentOnApproval.HasValue)
            {
                int requiredRadioButtonValue = terminationRequest.InitiateAmendmentOnApproval == true ? 1 : 0;
                IWebElement requiredInitiateAmendmentOnApprovalRadioButton = _driver.WaitForElement(By.XPath($"//label[text()='Initiate Amendment on Approval?']/following::input[@type='radio' and @value='{requiredRadioButtonValue}']"));
                requiredInitiateAmendmentOnApprovalRadioButton.Click();
            }

            if (terminationRequest.TerminationComments != null)
            {
                IWebElement terminationCommentsTextarea = _driver.WaitForElement(By.XPath("//label[text()='Termination Comments']/following::textarea"));
                terminationCommentsTextarea.SendKeys(terminationRequest.TerminationComments);
            }

            // move to the allocation page of the wizard
            _driver.WaitForElement(By.Id("butNext")).Click();

            IWebElement notificationLabel = _driver.WaitForElement(By.XPath(validationNotificationLabelXPath));

            if (notificationLabel.Text.Contains(validationErrorPrefix))
            {
                return notificationLabel.Text; // failed CVR contract validation rules
            }

            foreach (ContractTerminationRequest.AllocationTerminationRequest allocation in terminationRequest.Allocations)
            {
                EnterAllocationTerminationDetails(allocation.AllocationNumber, allocation.AllocationStopNewStartsDate, allocation.AllocationTerminationDate);

                notificationLabel = _driver.WaitForElement(By.XPath(validationNotificationLabelXPath));

                if (notificationLabel.Text.Contains(validationErrorPrefix))
                {
                    return notificationLabel.Text; // failed CAVR allocation validation rules
                }
            }

            // move to the final page of the wizard
            _driver.WaitForElement(By.Id("butNext")).Click();

            // wait for the next wizard page to load before checking for final validation errors
            _driver.WaitForElement(By.Id("butCancel"));

            if (_driver.HasElement(By.XPath(validationNotificationLabelXPath)))
            {
                notificationLabel = _driver.FindElement(By.XPath(validationNotificationLabelXPath));

                if (notificationLabel.Text.Contains(validationErrorPrefix))
                {
                    return notificationLabel.Text; // failed CAFV final validation rules
                }
            }

            // exit
            if (_driver.HasElement(By.Id("butNext")))
            {
                _driver.WaitForElement(By.Id("butNext")).Click();
            }
            _driver.FindElement(By.Id("butFinish")).Click();

            return string.Empty; // no errors
        }

        private void EnterAllocationTerminationDetails(string allocationNumber, DateTime? allocationStopNewStartsDate, DateTime? allocationTerminationDate)
        {
            IWebElement modifyIndividualAllocationsYesRadioButton = _driver.WaitForElement(By.XPath("//label[starts-with(text(),'To modify the dates')]/following::input[@type='radio' and @value='1']"));
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
