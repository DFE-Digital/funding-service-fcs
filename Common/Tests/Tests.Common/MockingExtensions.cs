namespace UnitTests.Common
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using Moq;

    public static class MockingExtensions
    {
        public static Mock<DbSet<T>> ToMockDbSet<T>(this ICollection<T> data) where T : class
        {
            Mock<DbSet<T>> mock = new Mock<DbSet<T>>();

            mock.As<IQueryable<T>>().Setup(m => m.Provider).Returns(data.AsQueryable().Provider);
            mock.As<IQueryable<T>>().Setup(m => m.Expression).Returns(data.AsQueryable().Expression);
            mock.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(data.AsQueryable().ElementType);
            mock.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(data.AsQueryable().GetEnumerator());
            mock.Setup(x => x.Add(It.IsAny<T>())).Callback<T>(data.Add);
            mock.Setup(x => x.Remove(It.IsAny<T>())).Callback<T>(t => data.Remove(t));

            return mock;
        }

        public static Mock<IDbSet<T>> ToMockIDbSet<T>(this ICollection<T> data) where T : class
        {
            Mock<IDbSet<T>> mock = new Mock<IDbSet<T>>();

            mock.As<IQueryable<T>>().Setup(m => m.Provider).Returns(data.AsQueryable().Provider);
            mock.As<IQueryable<T>>().Setup(m => m.Expression).Returns(data.AsQueryable().Expression);
            mock.As<IQueryable<T>>().Setup(m => m.ElementType).Returns(data.AsQueryable().ElementType);
            mock.As<IQueryable<T>>().Setup(m => m.GetEnumerator()).Returns(data.AsQueryable().GetEnumerator());
            mock.Setup(x => x.Add(It.IsAny<T>())).Callback<T>(data.Add);
            mock.Setup(x => x.Remove(It.IsAny<T>())).Callback<T>(t => data.Remove(t));

            return mock;
        }
    }
}
