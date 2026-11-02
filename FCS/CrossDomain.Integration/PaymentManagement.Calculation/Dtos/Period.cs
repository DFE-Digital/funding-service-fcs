namespace PaymentManagement.Calculation.Dtos
{
    public class Period
    {
        private readonly int _period;

        public Period(int period)
        {
            _period = period;
        }

        public int Month => _period % 100;

        public int Year => _period / 100;

        public static implicit operator Period(int period) => new Period(period);
        public static implicit operator int(Period period) => period._period;

        public int GetTaxYear()
        {
            const int marchMonth = 3;
            if (Month > marchMonth)
            {
                return (Year % 100) * 100 + (Year + 1) % 100;
            }

            return (Year % 100 - 1) * 100 + Year % 100;
        }

        public int GetPreviousTaxYear()
        {
            const int marchMonth = 3;
            if (Month > marchMonth)
            {
                return (Year % 100 - 1) * 100 + Year % 100; ;
            }

            return (Year % 100 - 2) * 100 + (Year - 1) % 100;
        }

        public Period AddMonths(int months)
        {
            const int monthsInYear = 12;
            var newMonth = Month + months;
            var newYear = Year;
            if (newMonth > monthsInYear)
            {
                var numYearsToAdd = newMonth / monthsInYear;
                var overSpill = newMonth % monthsInYear;
                newYear += numYearsToAdd;
                newMonth = overSpill;
            }

            return newYear * 100 + newMonth;
        }

        public override bool Equals(object obj)
        {
            if (obj is Period other)
            {
                return other._period == _period;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return _period.GetHashCode();
        }

        public override string ToString()
        {
            return _period.ToString();
        }
    }
}
