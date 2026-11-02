namespace FCT.Operations.Maintenance.Endpoint.Tests.Handlers
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.Operations.Maintenance.Endpoint.Handlers;
    using System;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using SFA.FCT.Operations.Maintenance.Endpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using NServiceBus.Testing;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Linq;
    using System.Collections.Generic;
    using SFA.FCT.Operations.Maintenance.Endpoint.IoC;
    using NServiceBus;
    using SFA.FCS.Worker.Common;

    [TestClass]
    public class HousekeepProcessedMessageTablesHandlerTests
    {
        private static string ConnectionString => ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

        [TestMethod, TestCategory("UnitTest")]
        public void HousekeepProcessedMessageTablesHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(Mock.Of<ILogger>(), Mock.Of<IFcsConfiguration>()));
            container.Register(Component.For<IHandleMessages<HousekeepProcessedMessageTables>>()
                .ImplementedBy<HousekeepProcessedMessageTablesHandler>());
            using (container.BeginScope())
            {
                container.Resolve<IHandleMessages<HousekeepProcessedMessageTables>>();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void HousekeepProcessedMessageTablesHandler_ShouldWork()
        {
            // arrange
            const int noOfDaysForKeepingRecords = 120;
            var schemaNames = new List<string> { "AllocationDelivery", "PaymentSchedule", "ContractManagement" };

            var dateForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysForKeepingRecords).Date;

            const int noOfDaysOlderThanNoOfDaysForKeepingRecords = noOfDaysForKeepingRecords + 1;
            var dateOlderThanNoOfDaysForKeepingRecords = DateTime.UtcNow.Date.AddDays(-noOfDaysOlderThanNoOfDaysForKeepingRecords).Date;

            const string messageIdPrefix = "VeryOldMessageId";

            ClearTestMessageIdRecords(messageIdPrefix, schemaNames);
            CreateTestMessageIdRecords(messageIdPrefix, dateOlderThanNoOfDaysForKeepingRecords, schemaNames);

            schemaNames.ForEach(schemaName =>
            {
                var numberOfRecordsToBeRemovedBefore = GetCountOfRecordsToBeRemoved(dateForKeepingRecords, schemaName);
                Assert.IsTrue(numberOfRecordsToBeRemovedBefore >= 3, 
                    $"{schemaName}.ProcessedMessage test records were not setup correctly within arrange part of the test");
            });

            var handler = new HousekeepProcessedMessageTablesHandler(
                Mock.Of<ILogger>(),
                new SchemaQueryRepository(new LocalConfig()),
                new ProcessedMessageDeleteRepository(new LocalConfig()));

            var testableContext = new TestableMessageHandlerContext();

            // act
            handler.Handle(new HousekeepProcessedMessageTables(), testableContext).Wait();

            // assert
            schemaNames.ForEach(schemaName =>
            {
                var numberOfRecordsToBeRemovedAfter = GetCountOfRecordsToBeRemoved(dateForKeepingRecords, schemaName);
                Assert.AreEqual(0, numberOfRecordsToBeRemovedAfter, $"{schemaName}.ProcessedMessage. Not all expected records were removed");
            });
        }

        private static void ClearTestMessageIdRecords(string messageIdPrefix, List<string> schemaNames)
        {
            schemaNames.ForEach(schemaName =>
                {
                    var sql = $"delete from {schemaName}.ProcessedMessage where MessageId like @MessageIdPrefix";
                    ExecuteSql(sql, new { MessageIdPrefix = messageIdPrefix + "%" });
                }
            );
        }

        private static void CreateTestMessageIdRecords(string messageIdPrefix, DateTime ageOfProcessedMessage, List<string> schemaNames)
        {
            schemaNames.ForEach(schemaName =>
                {
                    var sql = $"insert {schemaName}.ProcessedMessage(MessageId, CreatedDate) values(@messageId, @ageOfProcessedMessage)";
                    Enumerable.Range(1, 3).Select(i => $"{messageIdPrefix}{i}").ToList().ForEach(messageId =>
                        ExecuteSql(sql, new { messageId, ageOfProcessedMessage }));
                }
            );
        }

        private static int GetCountOfRecordsToBeRemoved(DateTime removeOlderThanDate, string schemaName)
        {
            string sql = $"select count(*) from {schemaName}.ProcessedMessage where CreatedDate < @removeOlderThanDate";
            return ExecuteScalarSql<int>(sql, new { removeOlderThanDate });
        }

        private static void ExecuteSql(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                connection.Execute(sql, parameter);
            }
        }

        private static T ExecuteScalarSql<T>(string sql, object parameter)
        {
            using (var connection = new SqlConnection(ConnectionString))
            {
                return connection.ExecuteScalar<T>(sql, parameter);
            }
        }

    }
}