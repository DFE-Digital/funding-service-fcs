namespace ContractCreateDomain.Integration.ContractRequest
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using NServiceBus;
    using NServiceBus.Saga;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Commands;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Messages;
    using SFA.FCT.CrossDomain.Integration.Common.Serializers;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.Framework.Logging.NullObjects;

    public class UpdateDraftContractSagaOld : Saga<UpdateDraftContractSagaData>,
        IAmStartedByMessages<DraftContractUpdateRequestCommand>,
        IHandleMessages<FirstLevelValidationSuccess>,
        IHandleMessages<OrganisationEnrichmentComplete>,
        IHandleMessages<GetContractComplete>,
        IHandleMessages<MashContractComplete>,
        IHandleMessages<AddContractNumbersComplete>,
        IHandleMessages<TransformContractComplete>,
        IHandleMessages<DeliverableEnrichmentComplete>,
        IHandleMessages<ContractValueAggregationComplete>,
        IHandleMessages<GetUpdateDraftContractValidationReferenceDataComplete>,
        IHandleMessages<SecondLevelValidationSuccess>,
        IHandleMessages<DocumentGenerationComplete>,
        IHandleMessages<DraftContractUpdated>,
        IHandleMessages<UpdateDraftContractUnsuccessful>,
        IHandleTimeouts<UpdateDraftContractSagaTimeout>
    {
        private readonly TimeSpan _timeoutInterval = TimeSpan.FromMinutes(int.Parse(ConfigurationManager.AppSettings["ContractOperationSagaTimeoutInMinutes"]));

        public UpdateDraftContractSagaOld()
        {
            Logger = new LoggerNullObject();
        }

        public ILogger Logger { get; set; }

        public IFundingStreamConfigService FundingStreamConfigService { get; set; }

        public IContractRequestTransformer ContractRequestTransformer { get; set; }

        public void Handle(DraftContractUpdateRequestCommand message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.DraftContractUpdateRequestReceived,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                message.ContractRequest.correlationInfo.batchId,
                message.ContractRequest.contract.contracts[0].contractNumber);

            if (message.ContractRequest.errorInfo == null)
            {
                message.ContractRequest.errorInfo = new List<errorInfoType>();
            }

            Data.ProcessId = message.ContractRequest.correlationInfo.correlationId;
            Data.BatchId = message.ContractRequest.correlationInfo.batchId;
            Data.ContractRequestContract = message.ContractRequest.ConvertObjectToByteArray();
            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.UpdateRequestReceived;

            //// schedule timeout to stop saga from running continiously
            // check it hasn't already been setup by any other handler 
            if (false == Data.IsTimeoutAlreadyScheduled)
            {
                RequestTimeout<UpdateDraftContractSagaTimeout>(_timeoutInterval);
                Data.IsTimeoutAlreadyScheduled = true;
            }

            var command = new PerformFirstLevelValidationCommand
            {
                ContractRequest = message.ContractRequest
            };
            Bus.Send(command);
        }

        public void Handle(FirstLevelValidationSuccess message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.FirstlevelValidationSuccessRecieved,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                message.ContractRequest.correlationInfo.batchId,
                message.ContractRequest.contract.contracts[0].contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.FirstLevelValidationSuccess;
            PerformOrganisationEnrichmentCommand command = new PerformOrganisationEnrichmentCommand
            {
                ContractRequest = message.ContractRequest
            };
            Bus.Send(command);
        }

        public void Handle(OrganisationEnrichmentComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.OrganisationEnrichementCompleteReceived,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.OrganisationEnrichmentComplete;
            Data.ContractRequestContract = message.ContractRequest.ConvertObjectToByteArray();

            GetContractCommand command = new GetContractCommand
            {
                ProcessId = Data.ProcessId,
                ContractNumber = message.ContractRequest.contract.contracts[0].contractNumber,
                MasterContractNumber = message.ContractRequest.contract.contractNumber,
                Ukprn = message.ContractRequest.contract.contractor.ukprn.ToString()
            };
            Bus.Send(command);
        }

        public void Handle(GetContractComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.GetContractCompleteReceived,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.GetContractComplete;

            var command = new PerformMashContractCommand
            {
                Contract = message.Contract,
                ContractRequest = Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>()
            };
            Bus.Send(command);
        }

        public void Handle(MashContractComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.MashContractCompleteReceived, 
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.MashContractComplete;
            Data.ContractRequestContract = message.ContractRequest.ConvertObjectToByteArray();

            var command = new AddContractNumbersCommand
            {
                ContractRequest = message.ContractRequest
            };
            Bus.Send(command);
        }

        public void Handle(AddContractNumbersComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.AddContractNumbersCompleteReceived,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.ContractNumberAdditionComplete;
            Data.ContractRequestContract = message.ContractRequest.ConvertObjectToByteArray();

            var command = new PerformTransformContractCommand
            {
                ContractRequest = message.ContractRequest
            };
            Bus.Send(command);

            // Stop the message being sent to other non-saga handlers
            Bus.DoNotContinueDispatchingCurrentMessageToHandlers();
        }

        public void Handle(TransformContractComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.TransformContractCompleteReceived, 
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.TransformContractComplete;

            var command = new PerformDeliverableEnrichmentCommand
            {
                Contract = message.Contract
            };
            Bus.Send(command);
        }

        public void Handle(DeliverableEnrichmentComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.DeliverableEnrichmentCompleteReceived,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.DeliverableEnrichmentComplete;

            var command = new PerformContractValueAggregationCommand
            {
                Contract = message.Contract
            };
            Bus.Send(command);
        }

        public void Handle(ContractValueAggregationComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.ContractValueAggregationCompleteReceived, 
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.ContractValueAggregationComplete;
            
            // we have received an Extended Corp Contract, Doc Gen requires a Corp Contract so transform
            var corpContract = ContractRequestTransformer.TransformToCorpContract(message.Contract);
            Data.CorporateContract = corpContract.ConvertObjectToByteArray();

            var command = new GetUpdateDraftContractValidationReferenceDataCommand();
            Bus.Send(command);
        }

        public void Handle(GetUpdateDraftContractValidationReferenceDataComplete message)
        {
            var contractRequest = Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>();

            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.GetUpdateDraftContractValidationReferenceDataCompleteReceived, 
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                contractRequest.contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.GetUpdateDraftContractValidationReferenceDataComplete;

            var deliverableStructures = new Dictionary<string, FSCDeliverableStructureDefinitionResponse>();

            contractRequest.contract.contracts.ForEach(con => con.contractAllocations.ForEach(all =>
            {
                if (!deliverableStructures.ContainsKey(all.fundingStreamPeriodCode))
                {
                    deliverableStructures.Add(
                        all.fundingStreamPeriodCode,
                        FundingStreamConfigService.GetDeliverableStructure(all.fundingStreamPeriodCode));
                }
            }));

            var command = new PerformSecondLevelValidationCommand
            {
                ContractRequest = contractRequest,
                ContractTypes = message.ContractTypes,
                LepCodes = message.LepCodes,
                UopCodes = message.UopCodes,
                DeliverableStructures = deliverableStructures
            };
            Bus.Send(command);
        }

        public void Handle(SecondLevelValidationSuccess message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.SecondLevelValidationSuccessReceived,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.SecondLevelValidationSuccess;

            // Publish event to generate the documentation
            var command = new DocumentGenerationCommand
            {
                CorporateContract = Data.CorporateContract.ConvertByteArrayToObject<contract>()
            };
            Bus.Send(command);
        }

        public void Handle(DocumentGenerationComplete message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.DocumentGenerationComplete,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.DocumentGenerationComplete;

            UpdateDraftContractCommand command = new UpdateDraftContractCommand
            {
                ProcessId = Data.ProcessId,
                Contract = Data.CorporateContract.ConvertByteArrayToObject<SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.contractType>()
            };
            Bus.Send(command);

            // Stop the message being sent to other non-saga handlers
            Bus.DoNotContinueDispatchingCurrentMessageToHandlers();
        }

        public void Handle(DraftContractUpdated message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.DraftContractUpdatedReceived,
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.DraftContractUpdated;

            Bus.Send<ContractRequestProcessedMessage>(
                c =>
                {
                    c.ContractRequest = Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>();
                });
            MarkAsComplete();
        }

        public void Handle(UpdateDraftContractUnsuccessful message)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.UpdateDraftContractUnsuccessfulReceived, 
                "{0} message received. ProcessId:{1}, BatchId:{2}, ContractNumber{3}:",
                message.GetType(),
                Data.ProcessId,
                Data.BatchId,
                Data.ContractRequestContract.ConvertByteArrayToObject<contractRequestType>().contract.contracts[0]
                    .contractNumber);

            Data.StatusInt = (int)UpdateDraftContractSagaStatusEnum.UpdateDraftContractUnsuccessful;

            contractRequestType contractRequestToPublish = message.ContractRequest ??
                                                           Data.ContractRequestContract
                                                               .ConvertByteArrayToObject<contractRequestType>();
            if (null != message.Error)
            {
                contractRequestToPublish.errorInfo.Add(message.Error);
            }

            Bus.Send<ContractRequestProcessedMessage>(c => { c.ContractRequest = contractRequestToPublish; });
            MarkAsComplete();
        }

        public void Timeout(UpdateDraftContractSagaTimeout state)
        {
            Logger.LogInformation(
                ContractCreateDomainEventLoggingId.UpdateSagaTimeout,
                "Timeout occurred in UpdateDraftContractSaga. Id:{0}, ProcessId:{1}, State:{2}, Originator:{3}, OriginalMessageId:{4}",
                Data.Id,
                Data.ProcessId,
                Enum.GetName(typeof(UpdateDraftContractSagaStatusEnum), (UpdateDraftContractSagaStatusEnum)Data.StatusInt),
                Data.Originator,
                Data.OriginalMessageId);

            MarkAsComplete();
        }

        protected override void ConfigureHowToFindSaga(SagaPropertyMapper<UpdateDraftContractSagaData> mapper)
        {
            mapper.ConfigureMapping<IDraftContractUpdateRequestedEvent>(msg => msg.ProcessId)
                .ToSaga(data => data.ProcessId);
        }
    }
}