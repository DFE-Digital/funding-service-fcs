namespace SFA.FCT.Xrm.TestFramework
{
    using System;
    using System.Linq;
    using System.ServiceModel;
    using System.Text;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using Services;

    /// <summary>
    ///     ICrmOrganisationService
    /// </summary>
    public interface ICrmOrganisationService
    {
        IOrganizationService OrganizationService { get; }

        Entity RetrieveSolution(string solutionName);
        
        OrganizationResponse Execute(OrganizationRequest organizationRequest);
        
        void Update(Entity solutionChanges);
    }

    public class CrmOrganisationService : IDisposable, ICrmOrganisationService
    {
        public IOrganizationService OrganizationService => CrmConnectionFactory.GetConnection();

        public CrmOrganisationService(string connectionString)
        {
        }

        public CrmOrganisationService(IOrganizationService organizationService)
        {
        }

        public Entity RetrieveSolution(string solutionName)
        {
            var query = new QueryExpression("solution")
            {
                ColumnSet = new ColumnSet(true)
            };
            query.Criteria.AddCondition("uniquename", ConditionOperator.Equal, solutionName);

            var solution = OrganizationService.RetrieveMultiple(query).Entities.FirstOrDefault();
            if (solution == null)
            {
                throw new Exception(string.Format("Solution {0} could not be found", solutionName));
            }

            return solution;
        }

        public OrganizationResponse Execute(OrganizationRequest organizationRequest)
        {
            return OrganizationService.Execute(organizationRequest);
        }

        public void Update(Entity entityToUpdate)
        {
            var sb = new StringBuilder(1000);
            try
            {
                OrganizationService.Update(entityToUpdate);
            }
            catch (FaultException<OrganizationServiceFault> ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat("Timestamp: {0}", ex.Detail.Timestamp);
                sb.AppendFormat("Code: {0}", ex.Detail.ErrorCode);
                sb.AppendFormat("Message: {0}", ex.Detail.Message);
                sb.AppendFormat("Inner Fault: {0}", null == ex.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");

                Assert.Fail("Organization Service Fault " + sb);
            }
            catch (TimeoutException ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat("Message: {0}", ex.Message);
                sb.AppendFormat("Stack Trace: {0}", ex.StackTrace);
                sb.AppendFormat("Inner Fault: {0}", ex.InnerException.Message);

                Assert.Fail("Timeout Exception " + sb);
            }
            catch (Exception ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat(ex.Message);

                // Display the details of the inner exception.
                if (ex.InnerException != null)
                {
                    sb.AppendFormat(ex.InnerException.Message);

                    var fe = ex.InnerException as FaultException<OrganizationServiceFault>;
                    if (fe != null)
                    {
                        sb.AppendFormat("Timestamp: {0}", fe.Detail.Timestamp);
                        sb.AppendFormat("Code: {0}", fe.Detail.ErrorCode);
                        sb.AppendFormat("Message: {0}", fe.Detail.Message);
                        sb.AppendFormat("Trace: {0}", fe.Detail.TraceText);
                        sb.AppendFormat("Inner Fault: {0}", null == fe.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");
                    }
                }

                Assert.Fail("Exception: " + sb);
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public Guid Create(Entity entityToCreate)
        {
            var sb = new StringBuilder(1000);
            var returnGuid = Guid.Empty;
            try
            {
                returnGuid = OrganizationService.Create(entityToCreate);
            }
            catch (FaultException<OrganizationServiceFault> ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat("Timestamp: {0}", ex.Detail.Timestamp);
                sb.AppendFormat("Code: {0}", ex.Detail.ErrorCode);
                sb.AppendFormat("Message: {0}", ex.Detail.Message);
                sb.AppendFormat("Inner Fault: {0}", null == ex.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");

                Assert.Fail("Organization Service Fault " + sb);
            }
            catch (TimeoutException ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat("Message: {0}", ex.Message);
                sb.AppendFormat("Stack Trace: {0}", ex.StackTrace);
                sb.AppendFormat("Inner Fault: {0}", ex.InnerException.Message);

                Assert.Fail("Timeout Exception " + sb);
            }
            catch (Exception ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat(ex.Message);

                // Display the details of the inner exception.
                if (ex.InnerException != null)
                {
                    sb.AppendFormat(ex.InnerException.Message);

                    var fe =
                        ex.InnerException as FaultException<OrganizationServiceFault>;
                    if (fe != null)
                    {
                        sb.AppendFormat("Timestamp: {0}", fe.Detail.Timestamp);
                        sb.AppendFormat("Code: {0}", fe.Detail.ErrorCode);
                        sb.AppendFormat("Message: {0}", fe.Detail.Message);
                        sb.AppendFormat("Trace: {0}", fe.Detail.TraceText);
                        sb.AppendFormat("Inner Fault: {0}", null == fe.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");
                    }
                }

                Assert.Fail("Exception: " + sb);
            }

            return returnGuid;
        }

        public void Delete(Entity entityToDelete)
        {
            var sb = new StringBuilder(1000);
            try
            {
                if (Exists(entityToDelete.Id, entityToDelete.LogicalName))
                {
                    OrganizationService.Delete(entityToDelete.LogicalName, entityToDelete.Id);
                }
            }
            catch (FaultException<OrganizationServiceFault> ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat("Timestamp: {0}", ex.Detail.Timestamp);
                sb.AppendFormat("Code: {0}", ex.Detail.ErrorCode);
                sb.AppendFormat("Message: {0}", ex.Detail.Message);
                sb.AppendFormat("Inner Fault: {0}", null == ex.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");

                Assert.Fail("Organization Service Fault " + sb);
            }
            catch (TimeoutException ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat("Message: {0}", ex.Message);
                sb.AppendFormat("Stack Trace: {0}", ex.StackTrace);
                sb.AppendFormat("Inner Fault: {0}", ex.InnerException.Message);

                Assert.Fail("Timeout Exception " + sb);
            }
            catch (Exception ex)
            {
                sb.AppendFormat("The application terminated with an error.");
                sb.AppendFormat(ex.Message);

                // Display the details of the inner exception.
                if (ex.InnerException != null)
                {
                    sb.AppendFormat(ex.InnerException.Message);

                    var fe = ex.InnerException as FaultException<OrganizationServiceFault>;
                    if (fe != null)
                    {
                        sb.AppendFormat("Timestamp: {0}", fe.Detail.Timestamp);
                        sb.AppendFormat("Code: {0}", fe.Detail.ErrorCode);
                        sb.AppendFormat("Message: {0}", fe.Detail.Message);
                        sb.AppendFormat("Trace: {0}", fe.Detail.TraceText);
                        sb.AppendFormat("Inner Fault: {0}", null == fe.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");
                    }
                }

                Assert.Fail("Exception: " + sb);
            }
        }

        public EntityCollection RetrieveMultiple(QueryExpression request)
        {
            EntityCollection response = null;
            StringBuilder error;

            try
            {
                response = OrganizationService.RetrieveMultiple(request);
            }
            catch (FaultException<OrganizationServiceFault> ex)
            {
                error = new StringBuilder(1000);

                error.AppendLine("The application terminated with an error.");
                error.AppendFormat("Timestamp: {0}", ex.Detail.Timestamp);
                error.AppendFormat("Code: {0}", ex.Detail.ErrorCode);
                error.AppendFormat("Message: {0}", ex.Detail.Message);
                error.AppendFormat("Plugin Trace: {0}", ex.Detail.TraceText);
                error.AppendFormat("Inner Fault: {0}", null == ex.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");

                Assert.Fail("Organization Service Fault " + error);
            }
            catch (TimeoutException ex)
            {
                error = new StringBuilder(1000);
                error.AppendLine("The application terminated with an error.");
                error.AppendFormat("Message: {0}", ex.Message);
                error.AppendFormat("Stack Trace: {0}", ex.StackTrace);
                error.AppendFormat("Inner Fault: {0}", ex.InnerException.Message);

                Assert.Fail("TimeoutException " + error);
            }
            catch (Exception ex)
            {
                error = new StringBuilder(1000);
                error.AppendLine("The application terminated with an error.");
                error.AppendLine(ex.Message);

                // Display the details of the inner exception.
                if (ex.InnerException != null)
                {
                    error.AppendLine(ex.InnerException.Message);

                    var fe = ex.InnerException
                        as FaultException<OrganizationServiceFault>;
                    if (fe != null)
                    {
                        error.AppendFormat("Timestamp: {0}", fe.Detail.Timestamp);
                        error.AppendFormat("Code: {0}", fe.Detail.ErrorCode);
                        error.AppendFormat("Message: {0}", fe.Detail.Message);
                        error.AppendFormat("Plugin Trace: {0}", fe.Detail.TraceText);
                        error.AppendFormat("Inner Fault: {0}", null == fe.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");
                    }
                }

                Assert.Fail("Exception " + error);
            }

            // Additional exceptions to catch: SecurityTokenValidationException, ExpiredSecurityTokenException,
            // SecurityAccessDeniedException, MessageSecurityException, and SecurityNegotiationException.

            return response;
        }

        public Entity Retrieve(Guid recordId, string entityLogicalName)
        {
            Entity response = null;
            StringBuilder error;

            try
            {
                response = OrganizationService.Retrieve(entityLogicalName, recordId, new ColumnSet(true));
            }
            catch (FaultException<OrganizationServiceFault> ex)
            {
                error = new StringBuilder(1000);

                error.AppendLine("The application terminated with an error.");
                error.AppendFormat("Timestamp: {0}", ex.Detail.Timestamp);
                error.AppendFormat("Code: {0}", ex.Detail.ErrorCode);
                error.AppendFormat("Message: {0}", ex.Detail.Message);
                error.AppendFormat("Plugin Trace: {0}", ex.Detail.TraceText);
                error.AppendFormat("Inner Fault: {0}", null == ex.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");

                Assert.Fail("Organization Service Fault " + error);
            }
            catch (TimeoutException ex)
            {
                error = new StringBuilder(1000);
                error.AppendLine("The application terminated with an error.");
                error.AppendFormat("Message: {0}", ex.Message);
                error.AppendFormat("Stack Trace: {0}", ex.StackTrace);
                error.AppendFormat("Inner Fault: {0}", ex.InnerException.Message);

                Assert.Fail("TimeoutException " + error);
            }
            catch (Exception ex)
            {
                error = new StringBuilder(1000);
                error.AppendLine("The application terminated with an error.");
                error.AppendLine(ex.Message);

                // Display the details of the inner exception.
                if (ex.InnerException != null)
                {
                    error.AppendLine(ex.InnerException.Message);

                    var fe = ex.InnerException
                        as FaultException<OrganizationServiceFault>;
                    if (fe != null)
                    {
                        error.AppendFormat("Timestamp: {0}", fe.Detail.Timestamp);
                        error.AppendFormat("Code: {0}", fe.Detail.ErrorCode);
                        error.AppendFormat("Message: {0}", fe.Detail.Message);
                        error.AppendFormat("Plugin Trace: {0}", fe.Detail.TraceText);
                        error.AppendFormat("Inner Fault: {0}", null == fe.Detail.InnerFault ? "No Inner Fault" : "Has Inner Fault");
                    }
                }

                Assert.Fail("Exception " + error);
            }

            //// Additional exceptions to catch: SecurityTokenValidationException, ExpiredSecurityTokenException,
            //// SecurityAccessDeniedException, MessageSecurityException, and SecurityNegotiationException.

            return response;
        }

        public bool Exists(Guid recordId, string entityLogicalName)
        {
            bool response = false;
            StringBuilder error;

            try
            {
                var entity = OrganizationService.Retrieve(entityLogicalName, recordId, new ColumnSet(entityLogicalName + "id"));
                if (entity.Id == recordId)
                {
                    response = true;
                }
            }
            catch (Exception)
            {
                response = false;
            }

            return response;
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                // free managed resources
                if (OrganizationService is OrganizationService)
                {
                    (OrganizationService as OrganizationService).Dispose();
                }
            }
        }
    }
}