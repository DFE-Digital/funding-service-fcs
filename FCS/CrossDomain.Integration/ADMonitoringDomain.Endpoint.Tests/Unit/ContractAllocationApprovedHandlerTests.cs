namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Globalization;
    using System.Linq;
    using BusinessLogic;
    using DataStore.Model;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.AllocationDelivery.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using PaySchedAllocation = SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model.Allocation;

    [TestClass]
    public class ContractAllocationApprovedHandlerTests
    {
        private Mock<ILogger> _mockLogger;
        private Mock<IAllocationDeliveryMonitoringRepository> _mockRepo;
        private Mock<IAllocationDeliveryPerformanceMapper> _mockMapper;
        private Mock<IDate> _mockDateService;
        private Mock<IAtomGenerator> _mockAtomGenerator;

        [TestInitialize]
        public void Initialize()
        {
            _mockLogger = new Mock<ILogger>();
            _mockRepo = new Mock<IAllocationDeliveryMonitoringRepository>();
            _mockMapper = new Mock<IAllocationDeliveryPerformanceMapper>();
            _mockDateService = new Mock<IDate>();
            _mockAtomGenerator = new Mock<IAtomGenerator>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationDeliveryCommencedEvent_ShouldMapTheMessage_WhenNewAllocationAndIsPayOnActuals()
        {
            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnActuals);

            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());
         
            var testEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractReference = new contractReferenceType
                    {
                        contractVersionNumber = 1
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = "EOP1517"
                    }
                }
            };

            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            _mockMapper.Verify(x => x.Map(testEvent, It.IsAny<ConnectionInfo>()), Times.Once, "The mapper was not called with the correct event");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationDeliveryCommencedEvent_ShouldMapTheMessage_WhenNewAllocationAndIsExternallyPaid()
        {
            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoPay);

            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            var testEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractReference = new contractReferenceType
                    {
                        contractVersionNumber = 1
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = "EOP1517"
                    }
                }
            };

            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            _mockMapper.Verify(x => x.Map(testEvent, It.IsAny<ConnectionInfo>()), Times.Once, "The mapper was not called with the correct event");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationDeliveryCommencedEvent_ShouldCallStoreEventUsingTheMappedMessageAndCorrectCategory_WhenNewAllocationAndIsExternallyPaid()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoPay);
            AllocationDeliveryPerformance mappedEvent = new AllocationDeliveryPerformance
            {
                 contractAllocationNumber = "EOP-1234",
                 Contract = new contractReferenceTYPE
                 {
                     contractNumber = "EOP-9876"
                 }
            };
            _mockMapper.Setup(x => x.Map(It.IsAny<AllocationDeliveryCommencedEvent>(), It.IsAny<ConnectionInfo>())).Returns(mappedEvent);

            var testEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractReference = new contractReferenceType
                    {
                        contractVersionNumber = 1
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = "EOP1517"
                    }
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreEvent(It.Is<AllocationDeliveryPerformance>(y=> y == mappedEvent),AllocationDeliveryEntryCategory.NewContractAllocationApproved, It.IsAny<ConnectionInfo>()), Times.Once, "StoreEvent was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationDeliveryCommencedEvent_ShouldNotGenerateAtomFeed_WhenAmendedAllocationAndIsExternallyPaid()
        {
            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoPay);

            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            var data = new List<PaySchedAllocation>
            {
                new PaySchedAllocation{ VersionNumber = 1, AllocationNumber = "ALLF-01", ContractNumber = "TestConNumber", ContractVersionNumber = 2, FundingStreamPeriodCode = "24+ALLF1516" }
            }.AsQueryable();

            var testEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractAllocationNumber = "ALLF-01",
                    contractReference = new contractReferenceType
                    {
                        contractVersionNumber = 2 //Contract Amendment
                    },
                    fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                    {
                        fundingStreamPeriodCode = "24+ALLF1516"
                    }
                }
            };

            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            _mockAtomGenerator.Verify(x => x.GenerateAtomFeed(
                testEvent.Allocation.contractAllocationNumber,
                testEvent.Allocation.contractReference.contractVersionNumber,
                AllocationDeliveryEntryCategory.AmendedContractAllocationApproved,
                It.IsAny<ConnectionInfo>())
                , Times.Never, "The Atom feed generator was called when not expected");
        }

       [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationDeliveryCommencedEvent_ShouldCallStorePayloadWithTheMappedEvent_WhenContractIsNewAndIsPayOnProfile()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType()
                {
                    contractAllocationNumber = "A101",
                    contractReference = new contractReferenceType()
                    {
                        contractVersionNumber = 1 
                    }
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.Is<AllocationDeliveryEventReceived>(y => y.AllocationNumber == "A101"
                && y.CategoryName == Constants.CATEGORY_NEW_CONTRACT_ALLOCATION_APPROVED
                    && y.EventName == "AllocationDeliveryCommencedEvent"
                    && y.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture)
                    && y.Object == testEvent
                    && y.ObjectType == testEvent.GetType().AssemblyQualifiedName
                    && y.VersionNumber == 1), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Once, "StoreMessagePayload was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationDeliveryCommencedEvent_ShouldCallStorePayloadWithTheMappedEvent_WhenContractIsAmendedAndIsPayOnProfile()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType()
                {
                    contractAllocationNumber = "A101",
                    contractReference = new contractReferenceType()
                    {
                        contractVersionNumber = 2
                    }
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.Is<AllocationDeliveryEventReceived>(y => y.AllocationNumber == "A101"
                && y.CategoryName == Constants.CATEGORY_AMENDED_CONTRACT_ALLOCATION_APPROVED
                    && y.EventName == "AllocationDeliveryCommencedEvent"
                    && y.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture)
                    && y.Object == testEvent
                    && y.ObjectType == testEvent.GetType().AssemblyQualifiedName
                    && y.VersionNumber == 2), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Once, "StoreMessagePayload was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_AllocationDeliveryCommencedEvent_ShouldNotCreateAtomFeed_WhenContractIsAmendedAndIsPayOnActual()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            var data = new List<PaySchedAllocation>
            {
                new PaySchedAllocation{ VersionNumber = 1, AllocationNumber = "16-18APP-01", ContractNumber = "TestConNumber", ContractVersionNumber = 2, FundingStreamPeriodCode = "TestFsp" }
            }.AsQueryable();

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnActuals);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType()
                {
                    contractAllocationNumber = "16-18APP-01",
                    contractReference = new contractReferenceType()
                    {
                        contractVersionNumber = 2
                    }
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockAtomGenerator.Verify(x => x.GenerateAtomFeed(
                testEvent.Allocation.contractAllocationNumber,
                testEvent.Allocation.contractReference.contractVersionNumber,
                AllocationDeliveryEntryCategory.AmendedContractAllocationApproved,
                It.IsAny<ConnectionInfo>()), Times.Never, "GenerateAtomFeed was called when not expected");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentScheduleEvent_ShouldCallStorePayloadWithTheMappedEvent_WhenContractIsNewAndPayOnProfile()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationNumber = "A101",
                    ContractVersionNumber = 1
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.Is<AllocationDeliveryEventReceived>(y => y.AllocationNumber == "A101"
                && y.CategoryName == Constants.CATEGORY_NEW_CONTRACT_ALLOCATION_APPROVED
                    && y.EventName == "PaymentScheduleEvent"
                    && y.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture)
                    && y.Object == testEvent
                    && y.ObjectType == testEvent.GetType().AssemblyQualifiedName
                    && y.VersionNumber == 1), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Once, "StoreMessagePayload was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentScheduleEvent_ShouldNotCallStorePayload_WhenContractIsNewAndIsPayOnActuals()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnActuals);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationNumber = "A101",
                    ContractVersionNumber = 1
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.IsAny<AllocationDeliveryEventReceived>(), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Never, "StoreMessagePayload was called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentScheduleEvent_ShouldNotCallStorePayload_WhenContractIsNewAndIsExternallyPaid()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoPay);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationNumber = "A101",
                    ContractVersionNumber = 1
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.IsAny<AllocationDeliveryEventReceived>(), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Never, "StoreMessagePayload was called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentAggregatedEvent_ShouldCallStorePayloadWithTheMappedEvent_WhenContractIsNewAndIsPayOnProfile()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = "A101",
                    VersionNumber = 1
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.Is<AllocationDeliveryEventReceived>(y => y.AllocationNumber == "A101"
                && y.CategoryName == Constants.CATEGORY_NEW_CONTRACT_ALLOCATION_APPROVED
                    && y.EventName == "PaymentAggregatedEvent"
                    && y.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture)
                    && y.Object == testEvent
                    && y.ObjectType == testEvent.GetType().AssemblyQualifiedName
                    && y.VersionNumber == 1), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Once, "StoreMessagePayload was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentAggregatedEvent_ShouldCallStorePayloadWithTheMappedEvent_WhenContractIsAmendedAndIsPayOnProfile()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = "A101",
                    VersionNumber = 2
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.Is<AllocationDeliveryEventReceived>(y => y.AllocationNumber == "A101"
                && y.CategoryName == Constants.CATEGORY_AMENDED_CONTRACT_ALLOCATION_APPROVED
                    && y.EventName == "PaymentAggregatedEvent"
                    && y.EventReceived == DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture)
                    && y.Object == testEvent
                    && y.ObjectType == testEvent.GetType().AssemblyQualifiedName
                    && y.VersionNumber == 2), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Once, "StoreMessagePayload was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentAggregatedEvent_ShouldCallGenerateAtom_WhenContractIsAmendedAndIsPayOnProfile()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = "A101",
                    VersionNumber = 3
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockAtomGenerator.Verify(x => x.GenerateAtomFeed(
                testEvent.Allocation.AllocationNumber,
                testEvent.Allocation.VersionNumber,
                AllocationDeliveryEntryCategory.AmendedContractAllocationApproved,
                It.IsAny<ConnectionInfo>())
                , Times.Once, "The Atom feed generator was not called with the correct parameters");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentAggregatedEvent_ShouldNotCallStorePayload_WhenContractIsNewAndIsPayOnActuals()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnActuals);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = "A101",
                    VersionNumber = 1
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.IsAny<AllocationDeliveryEventReceived>(), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Never, "StoreMessagePayload was called ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentAggregatedEvent_ShouldNotCallStorePayload_WhenContractIsNewAndIsExternallyPaid()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoPay);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = "A101",
                    VersionNumber = 1
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.IsAny<AllocationDeliveryEventReceived>(), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Never, "StoreMessagePayload was called ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentAggregatedEvent_ShouldNotCallStorePayload_WhenContractIsAmendedndIsExternallyPaid()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoPay);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = "A101",
                    VersionNumber = 4
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreMessagePayload(It.IsAny<AllocationDeliveryEventReceived>(), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Never, "StoreMessagePayload was called ");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_PaymentAggregatedEvent_ShouldOnlyCallGenerateAtomFeed_WhenContractIsAmendedndIsPayOnInstruction()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnInstruction);
            _mockDateService.Setup(x => x.GetCalculationDate()).Returns(DateTime.ParseExact("01/01/2001 23:59:59", "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture));

            var testEvent = new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    AllocationNumber = "A101",
                    VersionNumber = 2,
                },
                PaymentEventOrigin = PaymentEventOrigin.AllocationDeliveryCommenced
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockAtomGenerator.Verify(x => x.GenerateAtomFeed("A101", 2, AllocationDeliveryEntryCategory.AmendedContractAllocationApproved, It.IsAny<ConnectionInfo>()), Times.Once, "GenerateAtomFeed was not called ");
            _mockRepo.Verify(x => x.StoreMessagePayload(It.IsAny<AllocationDeliveryEventReceived>(), It.IsAny<ConnectionInfo>(), It.IsAny<Type>()), Times.Never, "StoreMessagePayload was called ");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_AllocationDeliveryCommencedEvent_ShouldCreateAtomFeedItemWhenNewApprovedAllocationIsNoCalcAndNoPay()
        {
            // arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoCalcAndNoPay);

            // act
            handler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractReference = new contractReferenceType
                    {
                        contractVersionNumber = 1
                    }
                }
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            _mockRepo.Verify(m => m.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), AllocationDeliveryEntryCategory.NewContractAllocationApproved, It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_AllocationDeliveryCommencedEvent_ShouldCreateAtomFeedItemWhenAmendedApprovedAllocationIsNoCalcAndNoPay()
        {
            // arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoCalcAndNoPay);

            // act
            handler.Handle(new AllocationDeliveryCommencedEvent
            {
                Allocation = new allocationType
                {
                    contractReference = new contractReferenceType
                    {
                        contractVersionNumber = 2
                    }
                }
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            _mockRepo.Verify(m => m.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), AllocationDeliveryEntryCategory.AmendedContractAllocationApproved, It.IsAny<ConnectionInfo>()), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_PaymentScheduleEvent_ShouldNotCreateAtomFeedItemWhenNewApprovedAllocationIsNoCalcAndNoPay()
        {
            // arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoCalcAndNoPay);

            // act
            handler.Handle(new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    VersionNumber = 1
                }
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            _mockRepo.Verify(m => m.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
            _mockAtomGenerator.Verify(m => m.GenerateAtomFeed(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_PaymentScheduleEvent_ShouldNotCreateAtomFeedItemWhenAmendedApprovedAllocationIsNoCalcAndNoPay()
        {
            // arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoCalcAndNoPay);

            // act
            handler.Handle(new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    VersionNumber = 2
                }
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            _mockRepo.Verify(m => m.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
            _mockAtomGenerator.Verify(m => m.GenerateAtomFeed(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_PaymentAggregatedEvent_ShouldNotCreateAtomFeedItemWhenNewApprovedAllocationIsNoCalcAndNoPay()
        {
            // arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoCalcAndNoPay);

            // act
            handler.Handle(new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    VersionNumber = 1
                }
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            _mockRepo.Verify(m => m.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
            _mockAtomGenerator.Verify(m => m.GenerateAtomFeed(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_PaymentAggregatedEvent_ShouldNotCreateAtomFeedItemWhenAmendedApprovedAllocationIsNoCalcAndNoPay()
        {
            // arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                _mockAtomGenerator.Object,
                Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(x => x.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.NoCalcAndNoPay);

            // act
            handler.Handle(new PaymentAggregatedEvent
            {
                Allocation = new SFA.FCT.CrossDomain.Integration.Entities.CorporatePaymentAggregation.Allocation
                {
                    VersionNumber = 2
                }
            }, new TestableMessageHandlerContext()).Wait();

            // assert
            _mockRepo.Verify(m => m.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
            _mockAtomGenerator.Verify(m => m.GenerateAtomFeed(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractAllocationApprovedHandler_ShouldNotCreateAmendmentFeedItemForPopWhenPaymentScheduleEventArrives()
        {
            //Arrange
            var handler = new ContractAllocationApprovedHandler(
                _mockLogger.Object,
                _mockRepo.Object,
                _mockMapper.Object,
                _mockDateService.Object,
                Mock.Of<IAtomGenerator>(),
               Mock.Of<ISessionConnectionFactory>());

            _mockRepo.Setup(r => r.GetPaymentMethod(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(PaymentMethod.PayOnProfile);
            _mockRepo.Setup(r => r.GetAllocationDeliveryEventReceivedEntity(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(new AllocationDeliveryEventReceived());
            _mockMapper.Setup(mapper => mapper.Map(It.IsAny<AllocationDeliveryCommencedEvent>(), It.IsAny<PaymentScheduleEvent>(), It.IsAny<PaymentAggregatedEvent>(), It.IsAny<ConnectionInfo>()))
                .Returns(new AllocationDeliveryPerformance());

            var testEvent = new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationNumber = "A101",
                    ContractVersionNumber = 2
                }
            };

            //Act
            handler.Handle(testEvent, new TestableMessageHandlerContext()).Wait();

            //Assert
            _mockRepo.Verify(x => x.StoreEvent(It.IsAny<AllocationDeliveryPerformance>(), It.IsAny<AllocationDeliveryEntryCategory>(), It.IsAny<ConnectionInfo>()), Times.Never, "StoreMessagePayload was called");
        }
    }
}
