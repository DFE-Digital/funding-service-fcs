namespace XrmTestModel
{
    using System;

    public class XrmWorkflowHistory : WorkflowHistory, IUseXrmEntity<sfa_contracttransitionhistory>, IUseXrmService
    {
        private sfa_contracttransitionhistory _workflowHistoryEntity;

        private Guid? _workflowHistoryId;
        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public IOrganizationService OrgService { get; set; }

        public XrmWorkflowHistory()
        {
            OrgService = OrgServiceFactory.Create();
        }

        public void DefaultUser()
        {
            OrgService = OrgServiceFactory.Create();
        }

        public void SwitchUser(string userName)
        {
            OrgService = OrgServiceFactory.Create(userName);
        }

        public IUseXrmEntity<sfa_contracttransitionhistory> Get()
        {
            return Get(s => s.sfa_contracttransitionhistoryId == _workflowHistoryId);
        }

        public IUseXrmEntity<sfa_contracttransitionhistory> Get(string primaryFieldName)
        {
            return Get(s => s.sfa_name == primaryFieldName);
        }

        public IUseXrmEntity<sfa_contracttransitionhistory> Get(Func<sfa_contracttransitionhistory, bool> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmWorkflowHistory = xrmSvcContext.sfa_contracttransitionhistorySet.Single(predicate);

                if (_workflowHistoryId == null)
                {
                    _workflowHistoryId = xrmWorkflowHistory.Id;
                }

                TranslateFromXrm(xrmWorkflowHistory);

                _workflowHistoryEntity = xrmWorkflowHistory;
            }

            return this;
        }

        public Guid GetId()
        {
            return _workflowHistoryId ?? Guid.Empty;
        }

        public EntityReference GetEntityReference()
        {
            return new EntityReference(sfa_contracttransitionhistory.EntityLogicalName, GetId());
        }

        public void Save()
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                TranslateToXrm();
                xrmSvcContext.AddObject(_workflowHistoryEntity);
                xrmSvcContext.SaveChanges();
            }
        }

        public void TranslateFromXrm(sfa_contracttransitionhistory xrmWorkflowHistory)
        {
            Action = xrmWorkflowHistory.sfa_Action.Name;
            ContractNumber = xrmWorkflowHistory.sfa_Contract.Name;
            PreviousSubStatus = xrmWorkflowHistory.sfa_PreviousSubStatus.Name;
            NewSubStatus = xrmWorkflowHistory.sfa_NewSubStatus.Name;
        }

        public void TranslateToXrm()
        {
            _workflowHistoryEntity.sfa_Action = new XrmTransition().Get(Action).GetEntityReference();
            //// _workflowHistoryEntity.sfa_Contract = new XrmContract().Get(ContractNumber).GetEntityReference();
            //// _workflowHistoryEntity.sfa_PreviousSubStatus = new XrmStatus().Get(PreviousSubStatus).GetEntityReference();
            //// _workflowHistoryEntity.sfa_NewSubStatus = new XrmStatus.Get(NewSubStatus).GetEntityReference();
        }
    }
}