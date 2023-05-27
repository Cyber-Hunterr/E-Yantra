defmodule A do

  # Function that generates the list for array_of_digits randomly
  def random_list_generator do
    for _n <- 1..Enum.random(6..9), do: Enum.random(1..9)
  end

  # Function that generates the 2d matrix for matrix_of_sum randomly
  def random_matrix_generator do
    list_of_na = for _n <- 1..9, do: "na"
    recurse(list_of_na, Enum.random(3..5)) |>
    Enum.chunk_every(3)
  end

  # Helper function for `random_matrix_generator()`
  def recurse(list_of_na, 0), do: list_of_na
  def recurse(list_of_na, num_of_sum) do
    recurse(List.replace_at(list_of_na, Enum.random(0..8), Enum.random(11..20)), num_of_sum-1)
  end

  @doc """
  #Function name:
        valid_sum
  #Inputs:
        matrix_of_sum   : A 2d matrix containing two digit numbers for which subsebts are to be created
  #Output:
        List of all vallid sums from the given 2d matrix
  #Details:
        Finds the valid sum values from the given 2d matrix
  """
  def valid_sum(matrix_of_sum \\ random_matrix_generator()) do
#     IO.inspect matrix_of_sum, label:  "matrix_of_sum"
    ### Write your code here ###
    matrix_of_sum
    |>Enum.reduce([],fn x,acc -> acc ++ select(x) end)
  end
  def select(x) do
      Enum.filter x,fn b -> (b>0)&&(b < :atom) end
  end


  @doc """
  #Function name:
        sum_of_one
  #Inputs:
        array_of_digits : Array containing single digit numbers to satisty sum
        sum_val         : Any 2 digit value for which subsets are to be created
  #Output:
        List of list of all possible subsets
  #Details:
        Finds the all possible subsets from given array of digits for a 2 digit value
  """

  def sum_of_one(array_of_digits \\ random_list_generator(), sum_val \\ Enum.random(11..20)) do
#     IO.inspect array_of_digits, label:  "array_of_digits"
#     IO.inspect sum_val, label:  "sum_val"
    ### Write your code here ###
    if sum_val==0 do []
      else
      reversed_array = Enum.reverse(array_of_digits)
      all_mat = subsets(Enum.filter(reversed_array,fn element -> element > 0 end))
      all_mat
      |>Enum.filter(fn x -> sum(x)==sum_val end)
      |>Enum.reverse()
      end
  end

  def subsets([]), do: [[]]
      def subsets([h | t]) do
      t
      |> subsets()
      |> Enum.flat_map(&[[h | &1], &1])
      end
      def sum(m) do
      m
      |>Enum.reduce(0,fn x,acc -> acc + x end)
  end

  @doc """
  #Function name:
        sum_of_all
  #Inputs:
        array_of_digits : Array containing single digit numbers to satisty sum
        matrix_of_sum   : A 2d matrix containing two digit numbers for which subsebts are to be created
  #Output:
        Map of each sum value and it's respective subsets
  #Details:
        Finds the all possible subsets from given array of digits for all valid sums elements of given 2d matrix
  """
  def sum_of_all(array_of_digits \\ random_list_generator(), matrix_of_sum \\ random_matrix_generator()) do
#     IO.inspect array_of_digits, label:  "array_of_digits"
#     IO.inspect matrix_of_sum, label:  "matrix_of_sum"
    ### Write your code here ###
    valid_array = valid_sum(matrix_of_sum)
    Map.new(valid_array,fn y ->{y, sum_of_one(array_of_digits,y)} end)
  end

  @doc """
  #Function name:
        get_optimal_subsets
  #Inputs:
        array_of_digits : Array containing single digit numbers to satisty sum
        matrix_of_sum   : A 2d matrix containing two digit numbers for which subsebts are to be created
  #Output:
        Map containing the sums and corresponding subset as keys & values respectively
  #Details:
        Function that takes matrix_of_sum and array_of_digits as argument and select single subset for each sum optimally to satisfy maximum sums
  #Example call:
      Check Task 3A Document
  """
  def get_optimal_subsets(array_of_digits \\ random_list_generator(), matrix_of_sum \\ random_matrix_generator()) do
    IO.inspect array_of_digits, label:  "array_of_digits"
    IO.inspect matrix_of_sum, label:  "matrix_of_sum"
    ### Write your code here ###
    valid_sums = valid_sum(matrix_of_sum)
    valid_sums = Enum.sort(valid_sums)
    IO.inspect valid_sums, label:  "valid_sums"
    result = Map.new()
    a(array_of_digits,valid_sums,result)
    #     digits = array_of_digits
    #     for sum_val <- valid_sums,into: result do
      #       tsubsets = sum_of_one(digits,sum_val)
#       optimal_subset = List.first(tsubsets)
#       # result = Map.put(result,sum_val,optimal_subset)
#       # IO.inspect result, label:  "result"
#       digits = digits--optimal_subset
#       IO.inspect digits, label:  "digits"
#       {sum_val,optimal_subset}
#       end
  end
  def a(_,[],result) do
      result
  end
  def a([],valid_sums,result) do
      sum_val = List.first(valid_sums)
      IO.inspect sum_val, label:  "sum_val"
      result = Map.put_new(result,sum_val,[])
      IO.inspect result, label:  "result"
      new_sums = valid_sums -- [sum_val]
      IO.inspect new_sums, label:  "new_sums"
      a([],new_sums,result)
  end
  def a(array_of_digits,valid_sums,result) do
      sum_val = List.first(valid_sums)
      IO.inspect sum_val, label:  "sum_val"
      tsubsets = sum_of_one(array_of_digits,sum_val)
      IO.inspect tsubsets, label:  "tsubsets"
      if tsubsets == [] do
            # subset = []
            sorted_digits = Enum.sort(array_of_digits)
            subset = Enum.reduce_while(sorted_digits,[],fn x,acc ->
               if Enum.sum(acc++[x])<sum_val do
                  {:cont, acc++[x]}
               else
                  {:halt, acc}
               end
            end)
            IO.inspect subset, label:  "subset"
            result = Map.update(result,sum_val,[subset],fn y->y++[subset] end)
            IO.inspect result, label:  "result"
            new_digits = array_of_digits -- subset
            IO.inspect new_digits, label:  "new_digits"
            new_sums = valid_sums -- [sum_val]
            IO.inspect new_sums, label:  "new_sums"
            a(new_digits,new_sums,result)
      else
            subset = List.first(tsubsets)
            IO.inspect subset, label:  "subset"
            result = Map.update(result,sum_val,[subset],fn y->y++[subset] end)
            IO.inspect result, label:  "result"
            new_digits = array_of_digits -- subset
            IO.inspect new_digits, label:  "new_digits"
            new_sums = valid_sums -- [sum_val]
            IO.inspect new_sums, label:  "new_sums"
            a(new_digits,new_sums,result)
      end
  end
end
