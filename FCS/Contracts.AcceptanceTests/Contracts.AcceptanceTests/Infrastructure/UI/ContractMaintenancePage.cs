namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.UI
{
    using System;
    using OpenQA.Selenium;

    public class ContractMaintenancePage
    {
        private readonly CrmWebDriver _driver;

        private ContractMaintenancePage(CrmWebDriver driver)
        {
            _driver = driver;
        }

        public static ContractMaintenancePage Create(CrmWebDriver driver, Guid contractId)
        {
            driver.NavigateTo($@"main.aspx?etn=sfa_contract&pagetype=entityrecord&id={contractId:D}");

            IWebElement popoutIntoNewTabWithMenuItemsButton = driver.WaitForElement(By.Id("popoutButton"));
            popoutIntoNewTabWithMenuItemsButton.Click();
            driver.SwitchToPopupWindow();

            return new ContractMaintenancePage(driver);
        }

        public void RejectTermination(string rejectionReason)
        {
            _driver.SwitchToFrame("contentIFrame0");

            IWebElement nextActionButton = _driver.WaitForElement(By.Id("sfa_nextaction_i"));
            nextActionButton.Click();

            IWebElement rejectTerminationInitiationOption = _driver.WaitForElement(By.XPath("//ul[@id='sfa_nextaction_IMenu']//a[@title='Reject Termination Initiation']"));
            rejectTerminationInitiationOption.Click();

            IWebElement rejectionReasonMarker = _driver.WaitForElement(By.Id("sfa_reasonforrejection"));
            rejectionReasonMarker.Click();

            IWebElement rejectionReasonEdit = _driver.WaitForElement(By.Id("sfa_reasonforrejection_i"));
            rejectionReasonEdit.SendKeys(rejectionReason);

            _driver.SwitchToParentFrame();

            IWebElement saveAndCloseMenuLink = _driver.WaitForElement(By.XPath("//a[@class='ms-crm-Menu-Label']//span[contains(text(),'Save & Close')]"));
            saveAndCloseMenuLink.Click();
        }

        public void CancelTermination()
        {
            IWebElement terminationMenuLink = _driver.WaitForElement(By.XPath("//a[@class='ms-crm-Menu-Label']//span[contains(text(),'Termination')]"));
            terminationMenuLink.Click();
            _driver.SwitchToPopupWindow(3);

            IWebElement selectActionToBePerformedCancelTerminationRadioButton = _driver.WaitForElement(By.XPath("//tr[@id='1row']//input[@type='radio' and @value='2']"));
            selectActionToBePerformedCancelTerminationRadioButton.Click();

            _driver.WaitForElement(By.Id("butNext")).Click();
            _driver.WaitForElement(By.Id("butFinish")).Click();
        }

        public void CompleteTermination()
        {
            IWebElement terminationMenuLink = _driver.WaitForElement(By.XPath("//a[@class='ms-crm-Menu-Label']//span[contains(text(),'Termination')]"));
            terminationMenuLink.Click();
            _driver.SwitchToPopupWindow(3);

            IWebElement selectActionToBePerformedCompleteTerminationRadioButton = _driver.WaitForElement(By.XPath("//tr[@id='1row']//input[@type='radio' and @value='1']"));
            selectActionToBePerformedCompleteTerminationRadioButton.Click();

            _driver.WaitForElement(By.Id("butNext")).Click();
            _driver.WaitForElement(By.Id("butNext")).Click();
            _driver.WaitForElement(By.Id("butFinish")).Click();
        }
    }
}
