using System;
using System.Linq;
using System.ServiceModel;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Client;
using Microsoft.Xrm.Sdk.Query;
using System.Collections.Generic;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Plugins
{
    public class ReconciliationAmountRollUpPostUpdate : IPlugin
    {
        void IPlugin.Execute(IServiceProvider serviceProvider)
        {

            //Extract the tracing service for use in debugging sandboxed plug-ins.
            ITracingService tracingService =
                (ITracingService)serviceProvider.GetService(typeof(ITracingService));

            // Obtain the execution context from the service provider.
            IPluginExecutionContext context = (IPluginExecutionContext)
                serviceProvider.GetService(typeof(IPluginExecutionContext));

            // Obtain the organization service reference.
            IOrganizationServiceFactory serviceFactory =
                (IOrganizationServiceFactory)
                    serviceProvider.GetService(typeof(IOrganizationServiceFactory));
            IOrganizationService service = serviceFactory.CreateOrganizationService(context.UserId);

            // The InputParameters collection contains all the data passed in the message request.
            if (context.InputParameters.Contains("Target") &&
                context.InputParameters["Target"] is Entity)
            {

                tracingService.Trace("ReconciliationAmountRollUpPostUpdate started");
                // Obtain the target entity from the input parameters.
                Entity entity = (Entity)context.InputParameters["Target"];


                Entity PostImage = (Entity)context.PostEntityImages["PostUpdateImage"];


                if (context.MessageName != "Update" || context.PrimaryEntityName != "sfa_fcrallocation")
                { return; }
                else
                {
                    if (PostImage.Contains("sfa_fundingclaimreconciliationid"))
                    {
                        Guid fcrId = PostImage.GetAttributeValue<EntityReference>("sfa_fundingclaimreconciliationid").Id;

                        tracingService.Trace($"Funding Claim Reconciliation ID : {fcrId.ToString()}");


                        using (var orgContext = new OrganizationServiceContext(service))
                        {
                            var query = from fa in orgContext.CreateQuery("sfa_fcrallocation")
                                        where (Guid)fa["sfa_fundingclaimreconciliationid"] == fcrId
                                        select fa;

                            if (query.ToList().Count() > 0)
                            {
                                Entity fcr = new Entity("sfa_fundingclaimreconciliation");
                                fcr["sfa_fundingclaimreconciliationid"] = fcrId;
                                fcr["sfa_reconciliationvalue"] = query.ToList().Sum(x => x.Contains("sfa_reconciliationvalue") ? x.GetAttributeValue<decimal>("sfa_reconciliationvalue") : 0m);


                                service.Update(fcr);
                            }


                        }
                    }

                }
            }
        }

    }
}
