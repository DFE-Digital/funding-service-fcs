namespace FundingAllocation.Tests.Endpoints.DocumentGenerationComplete
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using FluentAssertions;
    using FundingAllocation.Endpoints.DocumentGenerationComplete;
    using FundingAllocation.Infrastructure;
    using LanguageExt;
    using Microsoft.Extensions.Configuration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DocumentGenerationCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_ShouldResolve()
        {
            //IWindsorContainer container = new WindsorContainer()
            //    .Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IConfigurationRoot>()))
            //    .Register(Component.For<DocumentGenerationCompleteHandler>());

            //container.BeginScope();

            //// act
            //container.Resolve<DocumentGenerationCompleteHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_ShouldSendCorrectTypeToCrmForTheIntent()
        {
            // arrange
            List<(ContractIntent intent, Type type)> inputAndExpected = new List<(ContractIntent intent, Type type)>
            {
                (ContractIntent.NewAmendment, typeof(CreateNewAmendedContractCommand)),
                (ContractIntent.RevisedNew, typeof(CreateNewAmendedContractCommand)),
                (ContractIntent.New, typeof(CreateContractCommand)),
                (ContractIntent.UpdateDraft, typeof(UpdateContractCommand)),
                (ContractIntent.UpdateDraftAmendment, typeof(UpdateContractCommand)),
                (ContractIntent.Amendment, typeof(AmendContractCommand)),

            };
            inputAndExpected.ForEach(i =>
            {
                Mock<IContractStorage> contractStorageMock = new Mock<IContractStorage>();
                contractStorageMock.Setup(s => s.GetContract(It.IsAny<string>(),default))
                    .ReturnsAsync(new ExtendedContractTypeAndIntent(null, i.intent));
                DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(Mock.Of<ILogger>(), contractStorageMock.Object);
                TestableMessageHandlerContext context = new TestableMessageHandlerContext();
                
                // act
                handler.Handle(new DocumentGenerationComplete
                {
                    Contract = new Contract()
                }, context).Wait();

                // assert
                context.SentMessages.Length.Should().Be(1);
                var sentMessage = context.SentMessages.Single();
                sentMessage.Should().NotBe(null);
                sentMessage.Message.Should().BeOfType(i.type, $"failed for intent: {i.intent}");
            });
        }
    }
}
