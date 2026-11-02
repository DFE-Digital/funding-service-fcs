namespace FCTCrmConfig.ConfigPackage
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Xml.Serialization;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Tooling.Connector;

    public class LoadXrmContractNumbers
    {
        private readonly IEnumerable<XrmContractNumber> _contractNumbers;

        private readonly CrmServiceClient _crmSvcClient;

        private readonly IObserver<DeploymentEvent> _eventStream;

        private Dictionary<string, Guid> _xrmAgencies;

        private Dictionary<string, Guid> _xrmFundingStreams;

        private Dictionary<string, Guid> _xrmFundingTypes;

        public LoadXrmContractNumbers(string fileName, CrmServiceClient crmSvcClient, IObserver<DeploymentEvent> eventStream)
        {
            _crmSvcClient = crmSvcClient;
            _eventStream = eventStream;

            var serializer = new XmlSerializer(typeof(XrmContractNumbers));
            using (var fileStream = new FileStream(fileName, FileMode.Open))
            {
                _contractNumbers = ((XrmContractNumbers)serializer.Deserialize(fileStream)).ContractNumbers;
            }
        }

        private void GetAgencies(OrganizationServiceContext context)
        {
            _xrmAgencies =
                context.CreateQuery("sfa_agency")
                    .ToDictionary(i => i["sfa_agencycode"].ToString().ToUpperInvariant(), i => i.Id);
        }

        private void GetFundingStreams(OrganizationServiceContext context)
        {
            _xrmFundingStreams =
                context.CreateQuery("sfa_fundingstream")
                    .ToDictionary(i => i["sfa_fundingstreamcode"].ToString().ToUpperInvariant(), i => i.Id);
        }

        private void GetFundingTypes(OrganizationServiceContext context)
        {
            _xrmFundingTypes =
                context.CreateQuery("sfa_fundingtype")
                    .ToDictionary(i => i["sfa_fundingtypecode"].ToString().ToUpperInvariant(), i => i.Id);
        }

        public void LoadContractNumbers()
        {
            using (var context = new OrganizationServiceContext(_crmSvcClient.OrganizationServiceProxy))
            {
                GetAgencies(context);
                GetFundingStreams(context);
                GetFundingTypes(context);

                foreach (var c in _contractNumbers)
                {
                    Entity matchingContract = null;
                    var dataGood = false;

                    switch (c.Type)
                    {
                        case XrmContractNumberType.Master:
                            var agencyId = _xrmAgencies.GetValueOrDefault(c.Agency.ToUpperInvariant());
                            if (!agencyId.Equals(Guid.Empty))
                            {
                                dataGood = true;
                                matchingContract =
                                    context.CreateQuery("sfa_contractnumber")
                                        .FirstOrDefault(
                                            n =>
                                                n.GetAttributeValue<OptionSetValue>("sfa_contractnumbertype").Value == ((int)c.Type) &&
                                                n.GetAttributeValue<EntityReference>("sfa_agencyid").Id == agencyId);
                            }
                            break;

                        case XrmContractNumberType.Contract:
                            var fundingTypeId = _xrmFundingTypes.GetValueOrDefault(c.FundingTypeCode.ToUpperInvariant());
                            if (!fundingTypeId.Equals(Guid.Empty))
                            {
                                dataGood = true;
                                matchingContract =
                                    context.CreateQuery("sfa_contractnumber")
                                        .FirstOrDefault(
                                            n =>
                                                n.GetAttributeValue<OptionSetValue>("sfa_contractnumbertype").Value == ((int)c.Type) &&
                                                n.GetAttributeValue<EntityReference>("sfa_fundingtypeid").Id == fundingTypeId);
                            }
                            break;

                        case XrmContractNumberType.Allocation:
                            var fundingStreamId = _xrmFundingStreams.GetValueOrDefault(c.FundingStream.ToUpperInvariant());
                            if (!fundingStreamId.Equals(Guid.Empty))
                            {
                                dataGood = true;
                                matchingContract =
                                    context.CreateQuery("sfa_contractnumber")
                                        .FirstOrDefault(
                                            n =>
                                                n.GetAttributeValue<OptionSetValue>("sfa_contractnumbertype").Value == ((int)c.Type) &&
                                                n.GetAttributeValue<EntityReference>("sfa_fundingstreamid").Id == fundingStreamId);
                            }
                            break;
                    }

                    if (!dataGood)
                    {
                        _eventStream.OnNext(new DeploymentEvent
                        {
                            Level = DeploymentEvent.LogLevel.Warning,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Message = string.Format(
                                "Reference Data not found for Contract Number Type: {0}, AgencyCode: {1}, Funding Type: {2}, Funding Stream: {3}",
                                c.Type,
                                c.Agency,
                                c.FundingTypeCode,
                                c.FundingStream)
                        });
                    }
                    else if (matchingContract != null)
                    {
                        _eventStream.OnNext(new DeploymentEvent
                        {
                            Level = DeploymentEvent.LogLevel.Warning,
                            State = DeploymentEvent.OperationState.InProgress,
                            Type = DeploymentEvent.OperationType.RecordCreate,
                            Message = string.Format(
                                "Existing Contract Number found for Contract Number Type: {0}, AgencyCode: {1}, Funding Type: {2}, Funding Stream: {3}",
                                c.Type,
                                c.Agency,
                                c.FundingTypeCode,
                                c.FundingStream)
                        });
                    }
                    else
                    {
                        Func<string, Guid, EntityReference> enityReferenceDelegate = (s, g) => new EntityReference(s, g);

                        var xrmContractNo = new Entity("sfa_contractnumber");
                        xrmContractNo["sfa_contractnumbertype"] = new OptionSetValue((int)c.Type);
                        xrmContractNo["sfa_agencyid"] = _xrmAgencies.GetEntityReferenceOrDefault(c.Agency.ToUpperInvariant(), "sfa_agency", enityReferenceDelegate);
                        xrmContractNo["sfa_fundingtypeid"] = _xrmFundingTypes.GetEntityReferenceOrDefault(c.FundingTypeCode.ToUpperInvariant(), "sfa_fundingtype", enityReferenceDelegate);
                        xrmContractNo["sfa_fundingstreamid"] = _xrmFundingStreams.GetEntityReferenceOrDefault(c.FundingStream.ToUpperInvariant(), "sfa_fundingstream", enityReferenceDelegate);
                        xrmContractNo["sfa_lastnumber"] = c.LastNumber;
                        xrmContractNo["sfa_name"] = c.Name;

                        context.AddObject(xrmContractNo);

                        try
                        {
                            _eventStream.OnNext(new DeploymentEvent
                            {
                                Level = DeploymentEvent.LogLevel.Verbose,
                                State = DeploymentEvent.OperationState.InProgress,
                                Type = DeploymentEvent.OperationType.RecordCreate,
                                Message = string.Format(
                                    "Creating Contract Number for: {0}, AgencyCode: {1}, Funding Type: {2}, Funding Stream: {3}",
                                    c.Type,
                                    c.Agency,
                                    c.FundingTypeCode,
                                    c.FundingStream)
                            });

                            context.SaveChanges();
                        }
                        catch (Exception ex)
                        {
                            _eventStream.OnNext(new DeploymentEvent
                            {
                                Level = DeploymentEvent.LogLevel.Error,
                                State = DeploymentEvent.OperationState.InProgress,
                                Type = DeploymentEvent.OperationType.RecordCreate,
                                Message = string.Format(
                                    "Error Creating Contract Number for Contract Number Type: {0}, AgencyCode: {1}, Funding Type: {2}, Funding Stream: {3}, Exception: {4}, Inner Exception: {5}",
                                    c.Type,
                                    c.Agency,
                                    c.FundingTypeCode,
                                    c.FundingStream,
                                    ex.Message,
                                    ex.InnerException)
                            });
                        }
                    }
                }
            }
        }
    }
}