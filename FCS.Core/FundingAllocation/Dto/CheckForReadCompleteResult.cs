namespace FundingAllocation.Dto
{
    public class CheckForReadCompleteResult
    {
        public CheckForReadCompleteResult(bool isComplete, int readId)
        {
            IsComplete = isComplete;
            ReadId = readId;
        }

        public bool IsComplete { get; }
        public int ReadId { get; }

        public override string ToString()
        {
            return $"IsComplete: {IsComplete}, ReadId: {ReadId}";
        }
    }
}
