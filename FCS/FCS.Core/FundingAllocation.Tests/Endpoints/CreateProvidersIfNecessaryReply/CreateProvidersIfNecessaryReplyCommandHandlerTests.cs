namespace FundingAllocation.Tests.Endpoints.CreateProvidersIfNecessaryReply
{
    using System.Collections.Generic;
    using System.Linq;
    using AutoFixture;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using DataStore;
    using DataStore.Model;
    using FluentAssertions;
    using FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply;
    using FundingAllocation.Endpoints.CreateProvidersIfNecessaryReply.Services;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class CreateProvidersIfNecessaryReplyCommandHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryReplyHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
                .Register(Component.For<FundingAllocationContext>())
                .Register(Component.For<CreateProvidersIfNecessaryReplyHandler>());

            container.BeginScope();

            // act
            container.Resolve<CreateProvidersIfNecessaryReplyHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryReplyHandler_ShouldProcessFundingAllocationWhenProvidersExist()
        {
            // Arrange
            const string notRelevantString = "";
            var fixture = new Fixture();

            fixture.Customize<ProviderFunding>(c =>
                c.FromFactory(() => new ProviderFunding("id", 33, "type", "type")));

            var fundingAllocation = fixture.Create<FundingAllocation>();
            fundingAllocation.ProviderFundingAllocations.AddRange(fixture.Create<List<ProviderFundingAllocation>>());
            
            var mappingResult = fixture.Create<ContractItemsMappingResult>();

            var repository = new Mock<IFundingAllocationRepository>();
            var context = new TestableMessageHandlerContext();

            repository.Setup(r => r.GetFundingAllocation(fundingAllocation.FundingId))
                .ReturnsAsync(fundingAllocation);


            var target = new CreateProvidersIfNecessaryReplyHandler(
                repository.Object,
                Mock.Of<ILogger>(),
                Mock.Of<ICreateProvidersIfNecessaryNotificationService>());

            var command = new CreateProvidersIfNecessaryReply(fundingAllocation.FundingId, true, passedConfigValidation:true, 1, false, notRelevantString);

            // Act
            target.Handle(command, context).Wait();

            // Assert
            var sentCommand = context.SentMessages[0].Message<IgnoreItemsOfNoInterestCommand>();
            sentCommand.Should().NotBeNull("IgnoreItemsOfNoInterestCommand should have been sent");
            sentCommand.FundingAllocationIds.Single().Should().Be(fundingAllocation.FundingId);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryReplyHandler_ShouldParkFundingAllocationWhenProvidersDoNotExist()
        {
            // Arrange
            const string notRelevantString = "";
            var fixture = new Fixture();
            var fundingAllocation = fixture.Create<FundingAllocation>();

            var repository = new Mock<IFundingAllocationRepository>();
            var context = new TestableMessageHandlerContext();

            repository.Setup(r => r.GetFundingAllocation(fundingAllocation.FundingId))
                .ReturnsAsync(fundingAllocation);

            var target = new CreateProvidersIfNecessaryReplyHandler(
                repository.Object,
                Mock.Of<ILogger>(),
                Mock.Of<ICreateProvidersIfNecessaryNotificationService>());

            var command = new CreateProvidersIfNecessaryReply(fundingAllocation.FundingId, false, true, 1, false, notRelevantString);

            // Act
            target.Handle(command, context).Wait();

            // Assert
            context.SentMessages.Should().NotContain(message => message.Message is CreateFundingAllocationInCrmCommand);
            repository.Verify(r => r.SetFundingAllocationsParkedSubStatus(It.IsAny<List<string>>(), FundingAllocationSubStatus.AwaitingProvider));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryReplyHandler_ShouldSendCheckForJobComplete()
        {
            // Arrange
            const string notRelevantString = "";
            var fixture = new Fixture();
            var fundingAllocation = fixture.Create<FundingAllocation>();

            var repository = new Mock<IFundingAllocationRepository>();
            var context = new TestableMessageHandlerContext();

            repository.Setup(r => r.GetFundingAllocation(fundingAllocation.FundingId))
                .ReturnsAsync(fundingAllocation);

            
            var target = new CreateProvidersIfNecessaryReplyHandler(
                repository.Object,
                Mock.Of<ILogger>(),
                Mock.Of<ICreateProvidersIfNecessaryNotificationService>());

            var command = new CreateProvidersIfNecessaryReply(fundingAllocation.FundingId, false, true, 1, false, notRelevantString);

            // Act
            target.Handle(command, context).Wait();

            // Assert
            var sentCommand = context.SentMessages[0].Message<CheckForJobCompleteCommand>();
            sentCommand.Should().NotBeNull("CheckForJobCompleteCommand should have been sent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryReplyHandler_ShouldNotifiyWhen_ProviderCheckInProcessAndProviderFoundButConfigValidationFailed()
        {
            // Arrange
            const string awaitingFundingAllocationConfig = "AwaitingFundingAllocationConfig";
            const string fundingId = "1619-AS-2122-Contract-LocalAuthoritySsf-10028938-4_0";
            var mappingService = new Mock<ICfsToFcsCodeMappingService>();
            var repository = new Mock<IFundingAllocationRepository>();
            var notificationServiceMock = new Mock<ICreateProvidersIfNecessaryNotificationService>();
            var context = new TestableMessageHandlerContext();
            var target = new CreateProvidersIfNecessaryReplyHandler(
                repository.Object,
                Mock.Of<ILogger>(),
                notificationServiceMock.Object);

            var command = new CreateProvidersIfNecessaryReply(fundingId, true, false, 1, true, awaitingFundingAllocationConfig);

            // Act
            target.Handle(command, context).Wait();

            // Assert
           notificationServiceMock.Verify(n => n.NotifySlackRegardingProviderNotFoundChangedToConfigFailure(fundingId), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryReplyHandler_ShouldSetFundingAllocationStatusAndSubStatusToNotSetToWhenPuttingFundingAllocationIntoContractControl()
        {
            // Arrange
            const string notRelevantString = "";
            const bool notRelevantBool = true;
            const int notRelevantInt = -1;
            var fixture = new Fixture();
            var fundingAllocation = fixture.Create<FundingAllocation>();
            fundingAllocation.ProviderFundingAllocations.Add(fixture.Create<ProviderFundingAllocation>());

            var mappingService = new Mock<ICfsToFcsCodeMappingService>();
            var repository = new Mock<IFundingAllocationRepository>();
            var context = new TestableMessageHandlerContext();

            repository.Setup(r => r.GetFundingAllocation(fundingAllocation.FundingId))
                .ReturnsAsync(fundingAllocation);

            mappingService.Setup(ms => ms.GetContractItemsMappingResult(It.IsAny<ContractItemsMappingInput>()))
                .ReturnsAsync(fixture.Create<ContractItemsMappingResult>());

            var target = new CreateProvidersIfNecessaryReplyHandler(
                repository.Object,
                Mock.Of<ILogger>(),
                Mock.Of<ICreateProvidersIfNecessaryNotificationService>());

            var command = new CreateProvidersIfNecessaryReply(fundingAllocation.FundingId, true, true, notRelevantInt, notRelevantBool, notRelevantString);

            // Act
            target.Handle(command, context).Wait();

            // Assert
            repository.Verify(r => r.SetFundingAllocationStatusSubStatus(new List<string> {fundingAllocation.FundingId},
                    FundingAllocationStatus.NotSet, FundingAllocationSubStatus.NotSet), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateProvidersIfNecessaryReplyHandler_ShouldSetFundingAllocationStatusAndSubStatusToParkedAwaitingFundingAllocationConfigWhenChangedFromProviderNotFoundToConfigFailure()
        {
            // Arrange
            const string awaitingFundingAllocationConfig = "AwaitingFundingAllocationConfig";
            const int notRelevantInt = -1;
            var fixture = new Fixture();
            var fundingAllocation = fixture.Create<FundingAllocation>();
            fundingAllocation.ProviderFundingAllocations.Add(fixture.Create<ProviderFundingAllocation>());

            var mappingService = new Mock<ICfsToFcsCodeMappingService>();
            var repository = new Mock<IFundingAllocationRepository>();
            var context = new TestableMessageHandlerContext();

            repository.Setup(r => r.GetFundingAllocation(fundingAllocation.FundingId))
                .ReturnsAsync(fundingAllocation);

            mappingService.Setup(ms => ms.GetContractItemsMappingResult(It.IsAny<ContractItemsMappingInput>()))
                .ReturnsAsync(fixture.Create<ContractItemsMappingResult>());

            var target = new CreateProvidersIfNecessaryReplyHandler(
                repository.Object,
                Mock.Of<ILogger>(),
                Mock.Of<ICreateProvidersIfNecessaryNotificationService>());

            var command = new CreateProvidersIfNecessaryReply(fundingAllocation.FundingId, true, false, notRelevantInt, true, awaitingFundingAllocationConfig);
            // 2021-08-23 10:47:47:212 : Received CreateProvidersIfNecessaryReplyCommand for FundingId: NLG-AS-2122-Contract-Provider-10029520-1_1, AllProvidersExist: True,
            // PassedConfigValidation: False, ReadId: 803, IsPostReadProviderNotFoundCheck: True
            // Act
            target.Handle(command, context).Wait();

            // Assert
            repository.Verify(r => r.SetFundingAllocationsParkedSubStatus(new List<string> { fundingAllocation.FundingId },
                FundingAllocationSubStatus.AwaitingFundingAllocationConfig), Times.Once);
        }
    }
}