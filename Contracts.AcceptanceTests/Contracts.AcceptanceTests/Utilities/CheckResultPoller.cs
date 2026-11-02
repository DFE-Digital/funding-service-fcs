namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System;
    using System.Threading.Tasks;

    public class CheckResultPoller
    {
        private readonly Func<bool> _checkResult;
        private readonly int _maxNumChecks;
        private readonly int _waitIntervalSeconds;

        public CheckResultPoller(Func<bool> checkResult, int maxNumChecks, int waitIntervalSeconds)
        {
            _checkResult = checkResult;
            _maxNumChecks = maxNumChecks;
            _waitIntervalSeconds = waitIntervalSeconds;
        }

        public bool CheckResultAndWaitTillCompleteOrOutOfTime()
        {
            bool checkResultCompleteInTime = false;
            int numChecks = 0;
            while (numChecks < _maxNumChecks)
            {
                if (_checkResult())
                {
                    checkResultCompleteInTime = true;
                    break;
                }

                if (++numChecks < _maxNumChecks)
                {
                    Task.Delay(TimeSpan.FromSeconds(_waitIntervalSeconds)).Wait();
                }
            }

            return checkResultCompleteInTime;
        }

        public bool CheckResultAndWaitTillCompleteOrOutOfTimeWithGenericSqlErrorTolerance()
        {
            bool result = false;

            ActionRetrier.RetryWhenExceptionContainsText(
                action: () => result = CheckResultAndWaitTillCompleteOrOutOfTime(),
                text: "Generic SQL error");

            return result;
        }
    }
}
