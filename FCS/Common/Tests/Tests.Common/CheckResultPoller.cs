namespace UnitTests.Common
{
    using System;
    using System.Threading.Tasks;

    public class CheckResultPoller
    {
        private readonly Func<bool> _checkResult;
        private readonly int _maxNumChecks;
        private readonly int _waitIntervalSeconds;

        public CheckResultPoller(Func<bool> checkResult, int maxNumChecks = 3, int waitIntervalSeconds = 2)
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
    }
}
