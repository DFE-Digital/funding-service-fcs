namespace CrossDomain.XrmDevelopmentLibrary.Plugins
{
    using System;
    using System.Globalization;
    using System.Linq;
    using System.ServiceModel;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;

    public class ContractDeliverableDetectDuplicate : IPlugin
    {
        private const string ContractDeliverable = "sfa_contractdeliverable";
        private const int DuplicateDeliverableFound = 70000;
        private const string ContractAllocationId = "sfa_contractallocationid";
        private const string DeliverableCode = "sfa_deliverablecode";

        /// <summary>
        ///     Executes the plug-in.
        /// </summary>
        /// <param name="serviceProvider">The service provider.</param>
        /// <remarks>
        ///     For improved performance, Microsoft Dynamics CRM caches plug-in instances.
        ///     The plug-in's Execute method should be written to be stateless as the constructor
        ///     is not called for every invocation of the plug-in. Also, multiple system threads
        ///     could execute the plug-in at the same time. All per invocation state information
        ///     is stored in the context. This means that you should not use global variables in plug-ins.
        /// </remarks>
        public void Execute(IServiceProvider serviceProvider)
        {
            if (serviceProvider == null)
            {
                throw new ArgumentNullException("serviceProvider");
            }

            var localcontext = new LocalPluginContext(serviceProvider);

            localcontext.Trace(string.Format(CultureInfo.InvariantCulture, "Entered Execute()"));
            var context = localcontext.PluginExecutionContext;

            try
            {
                if (context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity)
                {
                    // Obtain the target entity from the input parameters.
                    Entity entity = (Entity)context.InputParameters["Target"];

                    // Verify that the target entity represents an Contract Deliverable.
                    if (entity.LogicalName == ContractDeliverable)
                    {
                        if (entity.Attributes.Contains(ContractAllocationId))
                        {
                            localcontext.Trace("Getting Allocation id");
                            var contractAllocationId = entity.GetAttributeValue<EntityReference>(ContractAllocationId);

                            localcontext.Trace("Getting Deliverable Code");
                            var deliverableCode = entity.GetAttributeValue<string>(DeliverableCode);

                            var allocationRef = entity.GetAttributeValue<string>("sfa_allocationref");

                            // Use the factory to generate the Organization Service.
                            using (var xrmContext = new OrganizationServiceContext(localcontext.OrganizationService))
                            {
                                var existingDeliverable = (from cd in xrmContext.CreateQuery(ContractDeliverable)
                                    where cd.GetAttributeValue<EntityReference>(ContractAllocationId).Equals(contractAllocationId)
                                    where cd.GetAttributeValue<string>(DeliverableCode).Equals(deliverableCode)
                                    select cd.Id).FirstOrDefault();

                                if (existingDeliverable != Guid.Empty)
                                {
                                    throw new InvalidPluginExecutionException(OperationStatus.Canceled, DuplicateDeliverableFound,
                                        string.Format("Contract Deliverable already exists for this allocation {0}. Deliverable Code : {1}", allocationRef, deliverableCode));
                                }
                            }
                        }
                    }
                }
            }
            catch (FaultException<OrganizationServiceFault> e)
            {
                localcontext.Trace(string.Format(CultureInfo.InvariantCulture, "Exception: {0}", e));

                // Handle the exception.
                throw;
            }
            finally
            {
                localcontext.Trace(string.Format(CultureInfo.InvariantCulture, "Exiting Execute()"));
            }
        }

        protected class LocalPluginContext
        {
            internal LocalPluginContext(IServiceProvider serviceProvider)
            {
                if (serviceProvider == null)
                {
                    throw new ArgumentNullException("serviceProvider");
                }

                // Obtain the execution context service from the service provider.
                PluginExecutionContext =
                    (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));

                // Obtain the tracing service from the service provider.
                TracingService = (ITracingService)serviceProvider.GetService(typeof(ITracingService));

                // Obtain the Organization Service factory service from the service provider
                var factory =
                    (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));

                // Use the factory to generate the Organization Service.
                OrganizationService = factory.CreateOrganizationService(PluginExecutionContext.UserId);
            }

            internal IServiceProvider ServiceProvider { get; private set; }
            internal IOrganizationService OrganizationService { get; private set; }
            internal IPluginExecutionContext PluginExecutionContext { get; private set; }
            internal ITracingService TracingService { get; private set; }

            internal void Trace(string message)
            {
                if (string.IsNullOrWhiteSpace(message) || TracingService == null)
                {
                    return;
                }

                if (PluginExecutionContext == null)
                {
                    TracingService.Trace(message);
                }
                else
                {
                    TracingService.Trace(
                        "{0}, Correlation Id: {1}, Initiating User: {2}",
                        message,
                        PluginExecutionContext.CorrelationId,
                        PluginExecutionContext.InitiatingUserId);
                }
            }
        }
    }
}