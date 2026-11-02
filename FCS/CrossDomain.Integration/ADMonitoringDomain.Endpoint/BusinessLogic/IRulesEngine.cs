namespace ADMonitoringDomain.Endpoint.BusinessLogic
{
    public interface IRulesEngine
    {
        bool EvaluateRule(RulesEngine.RuleName ruleName, RulesEngine.EventName eventName, string allocationNumber, int versionNumber);
    }
}