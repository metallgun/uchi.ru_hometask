import pandas as pd
from matplotlib import pyplot as plt

#Creating Error classes to support solution-specific exceptions
class GraphError(Exception):
    pass
class DataError(GraphError):
    def __init__(self, message):
        self.message = message

#Creating BaseGraph class with init and plot methods
class BaseGraph():
    def __init__(self, data, title=''):
        #1. Initializing data source, that must obey following rules:
        #Must be a csv file or DataFrame
        #Must have exactly 2 columns for x and y axises
        df = pd.DataFrame()

        if type(data) == str:
            try:
                df = pd.read_csv(data)
                print(df.head(5))
            except:
                raise DataError('Provided data source has no available csv data')
        elif type(data) == type(df):
            df = data
        else:
            raise DataError('Provided data source must be a csv file or Pandas DataFrame')

        if len(df.columns) != 2:
            raise DataError('Provided data source must have 2 columns')
        else:
            self.data = df

        self.title = title


    def plot(self):
        #2. Initializing plot method. x-axis data must be always in the first column, y-axis data - in the second column.
        plt.plot(
            self.data[self.data.columns[0]],
            self.data[self.data.columns[1]]
            )
        plt.title(self.title)
        plt.xlabel(self.data.columns[0])
        plt.ylabel(self.data.columns[1])
        plt.show()



class BarGraph(BaseGraph):
    def plot(self):
        plt.bar(
            self.data[self.data.columns[0]],
            self.data[self.data.columns[1]]
            )
        plt.title(self.title)
        plt.xlabel(self.data.columns[0])
        plt.ylabel(self.data.columns[1])
        plt.show()


def main():
    df1 = pd.read_csv('./data_samples/vgsales.csv')
    total_sales = df1[(df1.Year == 2015)].groupby('Platform')['Global_Sales'].sum().reset_index()

    total_sales_graph = BaseGraph(data=total_sales, title='Base Graph for Total Sales')
    total_sales_graph.plot()

    total_sales_bar = BarGraph(data=total_sales)
    total_sales_bar.plot()


if __name__ == "__main__":
    main()
