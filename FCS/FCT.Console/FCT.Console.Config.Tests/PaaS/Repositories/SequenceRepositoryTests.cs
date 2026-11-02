namespace FCT.Console.Config.Tests.PaaS.Repositories
{
    using System.Linq;
    using ContractManagement.DataStore;
    using Dapper;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.PaaS.Repositories;

    [TestClass]
    public class SequenceRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SequenceRepository_ShouldGetSequences()
        {
            // arrange
            const string sequenceName = "Test_seq";
            DropSequence(sequenceName);
            CreateSequence(sequenceName);

            // act
            using (var context = new ContractManagementDbContext())
            {
                var names = SequenceRepository.GetExistingSequenceNames(context.Database.Connection);
                // assert
                Assert.IsTrue(names.Contains(sequenceName));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SequenceRepository_ShouldCreateSequences()
        {
            // arrange
            const string sequenceName = "Test_seq";
            const int startingValue = 10;
            DropSequence(sequenceName);
            

            // act
            using (var context = new ContractManagementDbContext())
            {
                SequenceRepository.CreateSequence(context.Database.Connection, sequenceName, startingValue);
            }

            // assert
            var sequence = GetSequence(sequenceName);
            Assert.IsNotNull(sequence, "The sequence has not been created");
            Assert.AreEqual(startingValue, sequence.StartValue, "The sequence starting value has not been set correctly");
        }

        private void DropSequence(string sequenceName)
        {
            using (var context = new ContractManagementDbContext())
            {
                string sql = $@"IF EXISTS (SELECT * FROM sys.sequences WHERE object_id = object_id('ContractManagement.{sequenceName}'))
                             drop sequence ContractManagement.{sequenceName}";
                context.Database.Connection.Execute(sql);
            }
        }

        private void CreateSequence(string sequenceName)
        {
            using (var context = new ContractManagementDbContext())
            {
                string sql = $@"CREATE SEQUENCE ContractManagement.{sequenceName}  
                            START WITH 1
                            INCREMENT BY 1 ;";

                context.Database.Connection.Execute(sql);
            }
        }

        private Sequence GetSequence(string sequenceName)
        {
            using (var context = new ContractManagementDbContext())
            {
                string sql = @"SELECT  name,
                cast(start_value AS NUMERIC)   AS startvalue
                FROM sys.sequences
                where object_id = object_id(@name)";

                return context.Database.Connection.Query<Sequence>(sql, new {@name = $"ContractManagement.{sequenceName}"}).FirstOrDefault();
            }
        }

        private class Sequence
        {
            public string Name { get; }
            public decimal StartValue { get; }

            public Sequence(string name, decimal startValue)
            {
                Name = name;
                StartValue = startValue;
            }
        }
    }
}
