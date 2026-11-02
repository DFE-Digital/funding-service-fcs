namespace Operations.DataStore.Tests
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using Repositories;

    [TestClass]
    public class SessionRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SessionRepository_ShouldCreateSession()
        {
            // arrange
            using (var context = new OperationsDbContext())
            {
                context.Sessions.ForEach(s => context.Sessions.Remove(s));

                context.SaveChanges();
            }

            // act
            using (var context = new OperationsDbContext())
            {
                SessionRepository repository = new SessionRepository(context);

                var result = repository.CreateSessionAsync().Result;
            }

            // assert 
            using (var context = new OperationsDbContext())
            {
                Assert.AreEqual(1, context.Sessions.Count()); 
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SessionRepository_IsSessionPresentAsync()
        {
            // arrange
            using (var context = new OperationsDbContext())
            {
                context.Sessions.ForEach(s => context.Sessions.Remove(s));

                context.SaveChanges();
            }

            Guid sessionIdentifier;

            using (var context = new OperationsDbContext())
            {
                SessionRepository repository = new SessionRepository(context);

                sessionIdentifier = repository.CreateSessionAsync().Result;
            }

            bool isSessionPresent = false;
            // act 
            using (var context = new OperationsDbContext())
            {
                SessionRepository repository = new SessionRepository(context);

                isSessionPresent = repository.IsSessionPresentAsync(sessionIdentifier).Result;
            }

            // assert
            Assert.AreEqual(true, isSessionPresent);
        }
    }
}
