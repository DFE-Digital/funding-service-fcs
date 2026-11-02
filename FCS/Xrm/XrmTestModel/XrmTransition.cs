namespace XrmTestModel
{
    using System;

    public class XrmTransition : Transition, IUseXrmEntity<sfa_transition>, IUseXrmService
    {
        private Guid? _transitionId;

        private sfa_transition _transitionEntity;

        public IOrganizationService OrgService { get; set; }

        public IXrmServiceFactory OrgServiceFactory { get; set; }

        public XrmTransition()
        {
            OrgService = OrgServiceFactory.Create();
        }

        public void DefaultUser()
        {
            OrgService = OrgServiceFactory.Create();
        }

        public void SwitchUser(string username)
        {
            OrgService = OrgServiceFactory.Create(username);
        }

        public IUseXrmEntity<sfa_transition> Get()
        {
            return Get(s => s.sfa_transitionId == _transitionId);

        }

        public IUseXrmEntity<sfa_transition> Get(string primaryFieldName)
        {
            return Get(s => s.sfa_name == primaryFieldName);
        }

        public IUseXrmEntity<sfa_transition> Get(Func<sfa_transition, bool> predicate)
        {
            using (var xrmSvcContext = new XrmServiceContext(OrgService))
            {
                var xrmTransition = xrmSvcContext.sfa_transitionSet.Single(predicate);

                if (_transitionId != null)
                {
                    _transitionId = xrmTransition.Id;
                }

                TranslateFromXrm(xrmTransition);

                _transitionEntity = xrmTransition;

            }

            return this;
        }

        public Guid GetId()
        {
            return _transitionId.Value;
        }

        public EntityReference GetEntityReference()
        {
            return new EntityReference(sfa_transition.EntityLogicalName, _transitionId.Value);
        }

        public void Save()
        {
            throw new NotImplementedException();
        }

        public void TranslateFromXrm(sfa_transition xrmEntity)
        {
            throw new NotImplementedException();
        }

        public void TranslateToXrm()
        {
            throw new NotImplementedException();
        }

        
    }
}
