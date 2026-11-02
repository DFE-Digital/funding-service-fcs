namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.UI
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using OpenQA.Selenium;
    using OpenQA.Selenium.Chrome;
    using OpenQA.Selenium.Support.UI;

    public class CrmWebDriver : ChromeDriver
    {
        private const int TimeoutSeconds = 90;
        private const string defaultUsername = "fcs8.test";
        private static readonly Dictionary<string, string> allUsersAndPasswords = new Dictionary<string, string>
        {
            { "fcs1.test@education.gov.uk", "GhtyCv54Sdcf" },
            { "fcs2.test@education.gov.uk", "Ghbv56feSdmy" },
            { "fcs3.test@education.gov.uk", "Dfcv6te3SdxZ" },
            { "fcs4.test@education.gov.uk", "Sdx3Qwa8Jk6T" },
            { "fcs5.test@education.gov.uk", "Bnjm8yVgXcew" },
            { "fcs6.test@education.gov.uk", "Lm8u6rfX4eDX" },
            { "fcs7.test@education.gov.uk", "Nm8L9t5ECx3S" },
            { "fcs8.test@education.gov.uk", "Vb6fCv53DfcA" },
            { "fcs9.test@education.gov.uk", "Dfc4Sdc4QwaM" }
        };

        private CrmWebDriver()
        {
        }

        public static CrmWebDriver Create(string username = defaultUsername)
        {
            string userEmailAddress = $"{username.ToLower().Replace(" ", ".")}@education.gov.uk";
            string userPassword = allUsersAndPasswords[userEmailAddress];

            CrmWebDriver driver = new CrmWebDriver()
            {
                Url = ConfigurationManager.AppSettings["ida:ResourceId_CrmOnline"]
            };

            IWebElement emailAddressTextBox = driver.WaitForElement(By.Id("i0116"));
            emailAddressTextBox.SendKeys(userEmailAddress);

            IWebElement nextButton = driver.WaitForElement(By.Id("idSIButton9"));
            nextButton.Click();

            IWebElement passwordTextBox = driver.WaitForElement(By.Id("passwordInput"));
            passwordTextBox.SendKeys(userPassword);

            driver.WaitForElement(By.Id("submitButton")).Click();

            IWebElement doNotStaySignedInButton = driver.WaitForElement(By.Id("idBtn_Back"));
            doNotStaySignedInButton.Click();

            string parentWindowHandle = driver.CurrentWindowHandle;
            IWebElement exploreDynamics365Popup = driver.WaitForElement(By.Id("InlineDialog_Iframe"));
            driver.SwitchTo().Frame(exploreDynamics365Popup);
            driver.FindElement(By.Id("buttonClose")).Click();
            driver.SwitchTo().Window(parentWindowHandle);

            return driver;
        }

        public void NavigateTo(string path)
        {
            Url = Uri.EscapeUriString($@"{ConfigurationManager.AppSettings["ida:ResourceId_CrmOnline"]}/{path}");
        }

        public void SwitchToFrame(string id)
        {
            SwitchTo().Frame(WaitForElement(By.Id(id)));
        }

        public void SwitchToParentFrame()
        {
            SwitchTo().ParentFrame();
        }

        public void SwitchToPopupWindow(int windowNumber = 2)
        {
            Wait().Until(d => d.WindowHandles.Count >= windowNumber);
            SwitchTo().Window(WindowHandles[windowNumber - 1]);
        }

        public IWebElement WaitForElement(By findBy)
        {
            return Wait().Until(d =>
            {
                IWebElement element = d.FindElement(findBy);
                return element != null && element.Displayed ? element : null;
            });
        }

        public bool HasElement(By findBy)
        {
            try
            {
                IWebElement element = FindElement(findBy);
                return element.Displayed;
            }
            catch (NoSuchElementException)
            {
                return false;
            }
        }

        private WebDriverWait Wait()
        {
            WebDriverWait wait = new WebDriverWait(this, TimeSpan.FromSeconds(TimeoutSeconds));
            wait.IgnoreExceptionTypes(typeof(NoSuchElementException));

            return wait;
        }
    }
}