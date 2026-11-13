namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.UnitTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using Microsoft.Extensions.Logging;
    using Framework.Logging.NullObjects;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PaymentSchedule.DataStore.Model;
    using PaymentSchedule.DataStore.Repositories;
    using Services;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;
    using ProvisionIdentifier = CrossDomain.Integration.Entities.PaymentSchedule.ProvisionIdentifier;

    [TestClass]
    public class PaymentScheduleServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleService_ShouldNotAddOrUpdateAllocationWhenProcessingModeIsActualsReceived()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IProvisionIdentifierRepository> provisionIdentifierRepositoryMock =
                new Mock<IProvisionIdentifierRepository>();
            Mock<IOrganisationIdentifierRepository> organisationIdentifierRepositoryMock =
                new Mock<IOrganisationIdentifierRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock =
                new Mock<IDeliverablePaymentRepository>();

            PaymentScheduleService service = new PaymentScheduleService(
                allocationRepositoryMock.Object,
                provisionIdentifierRepositoryMock.Object,
                organisationIdentifierRepositoryMock.Object,
                deliverablePaymentRepositoryMock.Object,
                new LoggerNullObject());

            // act
            service.SavePaymentSchedule(
                new Allocation(),
                Enumerable.Empty<DeliverablePayment>().ToList(),
                ProcessingMode.ActualsReceived,
                null, null,
                ConnectionInfo.CreateDefault());

            // assert
            allocationRepositoryMock.Verify(r => r.AddOrUpdate(It.IsAny<PaymentSchedule.DataStore.Model.
                Allocation>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleService_ShouldAddOrUpdateAllocationWhenProcessingModeIsActualsReceived()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IProvisionIdentifierRepository> provisionIdentifierRepositoryMock =
                new Mock<IProvisionIdentifierRepository>();
            Mock<IOrganisationIdentifierRepository> organisationIdentifierRepositoryMock =
                new Mock<IOrganisationIdentifierRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock =
                new Mock<IDeliverablePaymentRepository>();

            PaymentScheduleService service = new PaymentScheduleService(
                allocationRepositoryMock.Object,
                provisionIdentifierRepositoryMock.Object,
                organisationIdentifierRepositoryMock.Object,
                deliverablePaymentRepositoryMock.Object,
                new LoggerNullObject());

            // act
            service.SavePaymentSchedule(
                new Allocation(),
                Enumerable.Empty<DeliverablePayment>().ToList(),
                ProcessingMode.ContractApproved,
                null, null,
                ConnectionInfo.CreateDefault());

            // assert
            allocationRepositoryMock.Verify(r => r.AddOrUpdate(It.IsAny<PaymentSchedule.DataStore.Model.
                Allocation>(), It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleService_ShouldAddOrUpdateOrganisation()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IProvisionIdentifierRepository> provisionIdentifierRepositoryMock =
                new Mock<IProvisionIdentifierRepository>();
            Mock<IOrganisationIdentifierRepository> organisationIdentifierRepositoryMock =
                new Mock<IOrganisationIdentifierRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock =
                new Mock<IDeliverablePaymentRepository>();

            IList<PaymentSchedule.DataStore.Model.OrganisationIdentifer> orgIdsAdded = new List<PaymentSchedule.DataStore.Model.OrganisationIdentifer>();
            organisationIdentifierRepositoryMock.Setup(r => r.AddOrUpdate(It.IsAny<PaymentSchedule.DataStore.Model.OrganisationIdentifer>(), It.IsAny<ConnectionInfo>()))
              .Callback((PaymentSchedule.DataStore.Model.OrganisationIdentifer orgId, ConnectionInfo ci) =>
              {
                  orgIdsAdded.Add(orgId);
              });

            PaymentScheduleService service = new PaymentScheduleService(
                allocationRepositoryMock.Object,
                provisionIdentifierRepositoryMock.Object,
                organisationIdentifierRepositoryMock.Object,
                deliverablePaymentRepositoryMock.Object,
                new LoggerNullObject());

            // act
            service.SavePaymentSchedule(
                new Allocation
                {
                    Organisation = new Organisation
                    {
                        OrganisationIdentifiers = new List<OrganisationIdentifier>
                        {
                            new OrganisationIdentifier
                            {
                                OrganisationIdentifierName = OrganisationIdentifierOrganisationIdentifierName.DENINUMBER
                            }
                        }
                    }
                },
                Enumerable.Empty<DeliverablePayment>().ToList(),
                ProcessingMode.ContractApproved,
                null, null,
                ConnectionInfo.CreateDefault());

            // assert
            organisationIdentifierRepositoryMock.Verify(r => r.AddOrUpdate(It.IsAny<PaymentSchedule.DataStore.Model.
                OrganisationIdentifer>(), It.IsAny<ConnectionInfo>()), Times.Once, "We have not called AddOrUpdate");
            Assert.AreEqual(1, orgIdsAdded.Count, "The OrganisationIdentifer was not added ");
            Assert.AreEqual(OrganisationIdentifierName.DENINUMBER, orgIdsAdded.First().OrganisationIdentifierName, "The OrganisationIdentifierName has not been set correctly");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleService_ShouldAddOrUpdateDeliverablePayment()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IProvisionIdentifierRepository> provisionIdentifierRepositoryMock =
                new Mock<IProvisionIdentifierRepository>();
            Mock<IOrganisationIdentifierRepository> organisationIdentifierRepositoryMock =
                new Mock<IOrganisationIdentifierRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock =
                new Mock<IDeliverablePaymentRepository>();

            IList<PaymentSchedule.DataStore.Model.DeliverablePayment> deliverablePayments = new List<PaymentSchedule.DataStore.Model.DeliverablePayment>();
            deliverablePaymentRepositoryMock.Setup(r => r.AddOrUpdateDeliverablePaymentsForAllocation(It.IsAny<IReadOnlyCollection<DeliverablePayment>>(), It.IsAny<string>(), It.IsAny<int>(), It.IsAny<ConnectionInfo>()))
              .Callback((IReadOnlyCollection<DeliverablePayment> dps, string allocationNumber, int version, ConnectionInfo ci) =>
              {
                  dps.ToList().ForEach(dp => deliverablePayments.Add(dp));
              });

            PaymentScheduleService service = new PaymentScheduleService(
                allocationRepositoryMock.Object,
                provisionIdentifierRepositoryMock.Object,
                organisationIdentifierRepositoryMock.Object,
                deliverablePaymentRepositoryMock.Object,
                new LoggerNullObject());

            // act
            service.SavePaymentSchedule(
                new Allocation(),
                new List<DeliverablePayment>
                {
                    new DeliverablePayment()
                }, 
                ProcessingMode.ContractApproved,
                null, null,
                ConnectionInfo.CreateDefault());

            // assert
            Assert.AreEqual(1, deliverablePayments.Count, "The DeliverablePayment was not added ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleService_ShouldAddOrUpdateProvisionIdentifier()
        {
            // arrange
            Mock<IAllocationRepository> allocationRepositoryMock = new Mock<IAllocationRepository>();
            Mock<IProvisionIdentifierRepository> provisionIdentifierRepositoryMock =
                new Mock<IProvisionIdentifierRepository>();
            Mock<IOrganisationIdentifierRepository> organisationIdentifierRepositoryMock =
                new Mock<IOrganisationIdentifierRepository>();
            Mock<IDeliverablePaymentRepository> deliverablePaymentRepositoryMock =
                new Mock<IDeliverablePaymentRepository>();

            IList<PaymentSchedule.DataStore.Model.ProvisionIdentifier> provisionIdentifiers = new List<PaymentSchedule.DataStore.Model.ProvisionIdentifier>();
            provisionIdentifierRepositoryMock.Setup(r => r.AddOrUpdate(It.IsAny<PaymentSchedule.DataStore.Model.ProvisionIdentifier>(), It.IsAny<ConnectionInfo>()))
              .Callback((PaymentSchedule.DataStore.Model.ProvisionIdentifier pi, ConnectionInfo ci) =>
              {
                  provisionIdentifiers.Add(pi);
              });

            PaymentScheduleService service = new PaymentScheduleService(
                allocationRepositoryMock.Object,
                provisionIdentifierRepositoryMock.Object,
                organisationIdentifierRepositoryMock.Object,
                deliverablePaymentRepositoryMock.Object,
                new LoggerNullObject());

            // act
            service.SavePaymentSchedule(
                new Allocation
                {
                    ProvisionIdentifiers = new List<ProvisionIdentifier>
                    {
                        new ProvisionIdentifier()
                    }
                },
                new List<DeliverablePayment>
                {
                    new DeliverablePayment()
                },
                ProcessingMode.ContractApproved,
                null, null,
                ConnectionInfo.CreateDefault());

            // assert
            provisionIdentifierRepositoryMock.Verify(r => r.AddOrUpdate(It.IsAny<PaymentSchedule.DataStore.Model.
                ProvisionIdentifier>(), It.IsAny<ConnectionInfo>()), Times.Once, "We have not called AddOrUpdate");
            Assert.AreEqual(1, provisionIdentifiers.Count, "A Provision Identifier was not added");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PaymentScheduleService_ShouldResolveFromPaymentScheduleEndpointContainer()
        {
            using (var container = new WindsorContainer()
                .Install(new PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(new LoggerFactory())))
            {
                container.BeginScope();
                container.Resolve<IPaymentScheduleService>();
            }
        }
    }
}
