namespace SFA.FCS.Worker.Common.Crm
{
    using System;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Polly;

    public class RetryOnErrorOrganizationService : IOrganizationService
    {
        private readonly IOrganizationService _organizationService;

        public RetryOnErrorOrganizationService(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Guid Create(Entity entity)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() => _organizationService.Create(entity));
        }

        public Entity Retrieve(string entityName, Guid id, ColumnSet columnSet)
        {
            return _organizationService.Retrieve(entityName, id, columnSet);
        }

        public void Update(Entity entity)
        {
            ActionRetrier.RetryWhenExceptionThrown(() => _organizationService.Update(entity));
        }

        public void Delete(string entityName, Guid id)
        {
            const string entityDoesNotExistExceptionMessage = "Does Not Exist";

            try
            {
                ActionRetrier.RetryWhenExceptionMatchesPredicate(
                    () => _organizationService.Delete(entityName, id),
                    (Exception ex) => !ex.Message.Contains(entityDoesNotExistExceptionMessage),
                    10); // allow more time for eventually consistent associations to be deleted in CRM Online
            }
            catch (Exception ex) when (ex.Message.Contains(entityDoesNotExistExceptionMessage))
            {
                // this is okay, the object has already been deleted
            }
        }

        public OrganizationResponse Execute(OrganizationRequest request)
        {
            return FunctionRetrier.RetryWhenExceptionThrown(() => _organizationService.Execute(request));
        }

        public void Associate(string entityName, Guid entityId, Relationship relationship, EntityReferenceCollection relatedEntities)
        {
            _organizationService.Associate(entityName, entityId, relationship, relatedEntities);
        }

        public void Disassociate(string entityName, Guid entityId, Relationship relationship, EntityReferenceCollection relatedEntities)
        {
            _organizationService.Disassociate(entityName, entityId, relationship, relatedEntities);
        }

        public EntityCollection RetrieveMultiple(QueryBase query)
        {
            return _organizationService.RetrieveMultiple(query);
        }

        private static class ActionRetrier
        {
            public static void RetryWhenExceptionThrown(Action action, int numRetries = 3, int numSecondsToWaitBetweenRetries = 2)
            {
                RetryWhenExceptionMatchesPredicate<Exception>(action, ex => true, numSecondsToWaitBetweenRetries, numRetries);
            }

            public static void RetryWhenExceptionMatchesPredicate<TException>(Action action, Func<TException, bool> exceptionPredicate, int numRetries = 3, int numSecondsToWaitBetweenRetries = 2)
                where TException : Exception
            {
                Policy.Handle(exceptionPredicate)
                    .WaitAndRetry(numRetries, count => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                    .Execute(action);
            }
        }

        private static class FunctionRetrier
        {
            public static T RetryWhenExceptionThrown<T>(Func<T> function, int numRetries = 3)
            {
                return RetryWhenExceptionMatchesPredicate(function, numRetries, ex => true);
            }

            private static T RetryWhenExceptionMatchesPredicate<T>(Func<T> function, int numRetries, Func<Exception, bool> exceptionPredicate)
            {
                const int numSecondsToWaitBetweenRetries = 2;

                return Policy.Handle(exceptionPredicate)
                    .WaitAndRetry(numRetries, count => TimeSpan.FromSeconds(numSecondsToWaitBetweenRetries))
                    .Execute(function);
            }
        }
    }
}
