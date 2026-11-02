namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.UI
{
    using OpenQA.Selenium;
    using OpenQA.Selenium.Support.UI;

    public class CfsAllocationReleaseDialog
    {
        private readonly CrmWebDriver _driver;

        private CfsAllocationReleaseDialog(CrmWebDriver driver)
        {
            _driver = driver;
        }

        public static CfsAllocationReleaseDialog Create(CrmWebDriver driver)
        {
            const string releaseDialogUrl = @"cs/dialog/rundialog.aspx?DialogId=84980EB8-EF98-4CEB-A272-B274F8C69B4C&EntityName=sfa_allocation&ObjectId=00000000-0000-0000-0000-000000000000";
            driver.NavigateTo(releaseDialogUrl);

            driver.WaitForElement(By.XPath("//div[@class='ms-crm-WizardForm-Main']"));
           
            return new CfsAllocationReleaseDialog(driver);
        }

        public void SelectFundingTypeFundingPeriod(string fundingTypeFundingPeriod)
        {
            // id = "InteractionStep16"
            IWebElement webElement = _driver.WaitForElement(By.Id("InteractionStep16"));
            SelectElement ftfpSelect = new SelectElement(webElement);

            ftfpSelect.SelectByText(fundingTypeFundingPeriod);
        }

        public void ClickNext()
        {
            ClickButton("butNext");
        }

        public void ClickFinish()
        {
           ClickButton("butFinish");
        }

        private void ClickButton(string id)
        {
            IWebElement webElement = _driver.WaitForElement(By.Id(id));

            webElement.Click();
        }
    }
}
