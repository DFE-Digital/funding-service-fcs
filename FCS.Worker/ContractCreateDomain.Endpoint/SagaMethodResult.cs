namespace ContractCreateDomain.Endpoint
{
    public class SagaMethodResult
    {
        public SagaMethodResult(bool isSagaComplete)
        {
            IsSagaComplete = isSagaComplete;
        }

        public bool IsSagaComplete { get; }
    }
}