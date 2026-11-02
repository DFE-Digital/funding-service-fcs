namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.UnitTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;
    using Model = PaymentSchedule.DataStore.Model;
    using System.Linq;

    [TestClass]
    public class PaymentScheduleAllocationCommandRepositoryTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void UpdateDeliverablePaymentsForAllocation_PaymentScheduleOrganisationIdentifierOrganisationIdentifierName_AllValuesShouldEnumParseTo_DataModelOrganisationIdentifierName()
        {
            Enum.GetValues(typeof(PaymentSchedule.OrganisationIdentifierOrganisationIdentifierName))
                .Cast<PaymentSchedule.OrganisationIdentifierOrganisationIdentifierName>()
                .ToList()
                .ForEach(value =>
                {
                    Model.OrganisationIdentifierName parsedValue;

                    if (!Enum.TryParse(value.ToString(), out parsedValue))
                    {
                        Assert.Fail($"Failed to parse value {value}");
                    }
                });
        }
    }
}
