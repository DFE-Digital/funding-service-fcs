namespace Datafix.Tests.Utils
{
    using System;

    internal class OrderAttribute : Attribute
    {
        public OrderAttribute(int order)
        {
            Order = order;
        }

        public int Order { get; private set; }
    }
}
