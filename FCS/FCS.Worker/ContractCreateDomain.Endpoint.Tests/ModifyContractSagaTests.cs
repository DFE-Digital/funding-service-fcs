namespace ContractCreateDomain.Endpoint.Tests
{
    using System.Collections.Generic;
    using ContractManagement.DataStore.Model;
    using Endpoint.Infrastructure.Extensions;
    using Endpoint.Services.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ModifyContractSagaTests
    {
        //[TestMethod, TestCategory("UnitTest")]
        //public void ModifyContractSaga_ShouldStoreCreatedContractRecordWhenContractSuccessfullyCreated()
        //{
        //    const string contractNumber = "TEST-1234";
        //    const int contractVersionNumber = 2;
        //    const int contractSubVersionNumber = 1;

        //    // arrange
        //    IMessageHandlerContext context = new TestableMessageHandlerContext();
        //    contractRequestType contract = new contractRequestType
        //    {
        //        contract = new contractType
        //        {
        //            contracts = new List<contractType>
        //            {
        //                new contractType
        //                {
        //                    contractNumber = contractNumber,
        //                    contractVersionNumber = contractVersionNumber,
        //                    contractSubVersionNumber = contractSubVersionNumber
        //                }
        //            }
        //        }
        //    };
        //    ModifyContractSagaData sagaData = new ModifyContractSagaData
        //    {
        //        MashedContractRequest = contract.ConvertObjectToByteArray()
        //    };
        //    Mock<ICreatedContractRepository> createdContractRepositoryMock = new Mock<ICreatedContractRepository>();

        //    // act
        //    ModifyContractSaga.Handle(new ContractAmended(), context, sagaData, Mock.Of<ILogger>(), createdContractRepositoryMock.Object).Wait();

        //    // assert
        //    createdContractRepositoryMock.Verify(
        //        m => m.Add(It.Is<CreatedContract>(c =>
        //            c.ContractNumber == contractNumber && c.ContractVersionNumber == contractVersionNumber && c.ContractSubVersionNumber == contractSubVersionNumber)),
        //        Times.Once,
        //        "CreatedContract entity was not stored");
        //}
    }
}
