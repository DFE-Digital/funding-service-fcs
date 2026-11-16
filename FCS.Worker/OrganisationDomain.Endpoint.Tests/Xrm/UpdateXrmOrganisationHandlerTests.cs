namespace OrganisationDomain.Endpoint.Tests.Xrm
{
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.Xrm;
    using Integration.Messages.Commands;
    using Integration.Messages.Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class UpdateXrmOrganisationHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateXrmOrganisationHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<UpdateXrmOrganisationHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<UpdateXrmOrganisationHandler>();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UpdateXrmOrganisationCommandHandler_ShouldUpdateCrmOrgWithSupplementaryDetails()
        {
            string ukprn;

            // arrange
            var crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            using (XrmServiceContext xrmContext = new XrmServiceContext(crmConnection))
            {
                Account account = xrmContext.AccountSet.First();

                ukprn = account.sfa_UKPRN;

                // clear the fields of this entity
                crmConnection.Update(new Account
                {
                    Id = account.Id,
                    sfa_UKPRN = ukprn,
                    EntityState = EntityState.Changed
                });
            }

            UpdateXrmOrganisationCommand updateCommand = new UpdateXrmOrganisationCommand
            {
                Ukprn = ukprn,
                CompanyNumber = "Test Company No",
                CharityNumber = "Test Charity No",
                Address = new OrgSupplementaryAddressDto
                {
                    Line1 = "Test Line 1",
                    Line2 = "Test Line 2",
                    Line3 = "Test Line 3",
                    Line4 = "Test Line 4",
                    Town = "Test Town",
                    County = "Test County",
                    Postcode = "Test PC"
                }
            };

            UpdateXrmOrganisationHandler handler = new UpdateXrmOrganisationHandler(Mock.Of<ILogger>(), CrmConnectionFactory.GetRetryOnErrorOrganizationService());

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(updateCommand, context).Wait();

            // assert
            using (XrmServiceContext xrmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                Account updatedAccount = xrmContext.AccountSet.First(a => a.sfa_UKPRN == ukprn);

                Assert.AreEqual("Test Company No", updatedAccount.sfa_companynumber, "Company number not set");
                Assert.AreEqual("Test Charity No", updatedAccount.sfa_charitynumber, "Charity number not set");
                Assert.AreEqual("Test Line 1", updatedAccount.Address1_Line1, "Address Line1 not set");
                Assert.AreEqual("Test Line 2", updatedAccount.Address1_Line2, "Address Line2 not set");
                Assert.AreEqual("Test Line 3", updatedAccount.Address1_Line3, "Address Line3 not set");
                Assert.AreEqual("Test Line 4", updatedAccount.Address1_Line4, "Address Line4 not set");
                Assert.AreEqual("Test Town", updatedAccount.Address1_Town, "Town not set");
                Assert.AreEqual("Test County", updatedAccount.Address1_County, "County not set");
                Assert.AreEqual("Test PC", updatedAccount.Address1_PostCode, "Postcode not set");
            }
        }
    }
}
