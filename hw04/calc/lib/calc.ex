defmodule Calc do
  def main() do
    IO.gets("> ") 
    |> eval()
    |> IO.inspect
    main()
  end

  defp checkStringValid(string) do
    if Regex.match?(~r{^[0-9()+-/*]+$} ,string) do
       list= String.split(string,"", trim: true) 
      |> List.delete("\n") 
      occurances_map = Enum.reduce(list,%{}, fn(tag, acc) -> Map.update(acc, tag, 1, &(&1 + 1)) end)
      if Map.fetch(occurances_map,"(") != :error && Map.fetch(occurances_map,")") != :error do
        if Map.fetch(occurances_map,"(") === Map.fetch(occurances_map,")") do 
          string
        end
      end
        if Map.fetch(occurances_map,"(") == :error && Map.fetch(occurances_map,")") == :error do
          string
        end
        if (Map.fetch(occurances_map,"(") != :error && Map.fetch(occurances_map,")") == :error) || (Map.fetch(occurances_map,"(") == :error && Map.fetch(occurances_map,")") != :error) do
          IO.puts "Invalid input"
          main()
        end
    else
      IO.puts "Invalid input"
      main()
    end
  end

  def eval(string) do
    string_new=
    String.split(string ,~r{\s+}) 
    |> Enum.join("")
    checkStringValid(string_new)
    list=String.split(string_new,"", trim: true) 
    |> List.delete("\n") 
    acc=evaluate(list,0)
    IO.inspect(acc)
  end

  def evaluate(list,acc) do
    cond do
      Enum.member?(list , "(") ->
        brackets_eval(list,acc)
      Enum.member?(list , "/") -> 
        division(list,acc)
      Enum.member?(list , "*") -> 
        multiplication(list,acc)
      Enum.member?(list , "+") ->
         addition(list,acc)
      Enum.member?(list , "-") ->
         subtraction(list,acc)
      true ->
        main()  
    end
    acc
  end

  defp addition(list,acc) do
      index =Enum.find_index(list, fn (x) -> x == "+" end)
      list_tuple=List.to_tuple(list)
      leftVal=
      if is_bitstring(Enum.at(list,index-1)) do
        if  Regex.match?(~r{[0-9]},Enum.at(list,index-1)) do
          String.to_integer(Enum.at(list,index-1))
      end
      else
          Enum.at(list,index-1)
      end
         rightVal=
         if is_bitstring(Enum.at(list,index+1)) do
          if  Regex.match?(~r{[0-9]},Enum.at(list,index+1)) do
            String.to_integer(Enum.at(list,index+1))
        end
      else
        Enum.at(list,index+1)
        end
        total = leftVal + rightVal 
        acc=acc+total |> IO.inspect
        Tuple.delete_at(list_tuple,index-1) 
        |> Tuple.delete_at(index-1)
        |> Tuple.delete_at(index-1)
        |> Tuple.insert_at(index-1 ,total)
        |> Tuple.to_list
        |> evaluate(acc)        
  end
  defp subtraction(list,acc) do
       index =Enum.find_index(list, fn (x) -> x == "-" end)
       list_tuple=List.to_tuple(list)
       leftVal=
       if is_bitstring(Enum.at(list,index-1)) do
         if  Regex.match?(~r{[0-9]},Enum.at(list,index-1)) do
           String.to_integer(Enum.at(list,index-1))
       end
      else
        Enum.at(list,index-1)
       end
      

          rightVal=
          if is_bitstring(Enum.at(list,index+1)) do
           if  Regex.match?(~r{[0-9]},Enum.at(list,index+1)) do
             String.to_integer(Enum.at(list,index+1))
         end
        else
          Enum.at(list,index+1)
         end
         total = leftVal - rightVal
         acc =total + acc|> IO.inspect
         Tuple.delete_at(list_tuple,index-1) 
         |> Tuple.delete_at(index-1)
         |> Tuple.delete_at(index-1)
         |> Tuple.insert_at(index-1 ,total)
         |> Tuple.to_list
         |> evaluate(acc)        
   end
   defp multiplication(list,acc) do
       index =Enum.find_index(list, fn (x) -> x == "*" end)
       list_tuple=List.to_tuple(list)
       leftVal=
       if is_bitstring(Enum.at(list,index-1)) do
         if  Regex.match?(~r{[0-9]},Enum.at(list,index-1)) do
           String.to_integer(Enum.at(list,index-1))
       end
       else
        Enum.at(list,index-1)
       end
          rightVal=
          if is_bitstring(Enum.at(list,index+1)) do
           if  Regex.match?(~r{[0-9]},Enum.at(list,index+1)) do
             String.to_integer(Enum.at(list,index+1))
         end
        else
          Enum.at(list,index+1)
         end
         total = leftVal * rightVal 
         acc= acc+total|> IO.inspect
         Tuple.delete_at(list_tuple,index-1) 
         |> Tuple.delete_at(index-1)
         |> Tuple.delete_at(index-1)
         |> Tuple.insert_at(index-1 ,total)
         |> Tuple.to_list
         |> evaluate(acc)        
   end
   defp division(list,acc) do
       index =Enum.find_index(list, fn (x) -> x == "/" end)
       list_tuple=List.to_tuple(list)
       leftVal =
       if is_bitstring(Enum.at(list,index-1)) do
         if  Regex.match?(~r{[0-9]},Enum.at(list,index-1)) do
           String.to_integer(Enum.at(list,index-1))
       end
      else
        Enum.at(list,index-1)
       end
          rightVal=
          if is_bitstring(Enum.at(list,index+1)) do
           if  Regex.match?(~r{[0-9]},Enum.at(list,index+1)) do
             String.to_integer(Enum.at(list,index+1))
         end
        else
          Enum.at(list,index+1)
         end

         if rightVal===0 do
           IO.puts "Division by zero is invalid"
           main()
         end

         total = div(leftVal,rightVal) 
         acc=total+acc
         Tuple.delete_at(list_tuple,index-1) 
         |> Tuple.delete_at(index-1)
         |> Tuple.delete_at(index-1)
         |> Tuple.insert_at(index-1 ,total)
         |> Tuple.to_list
         |> evaluate(acc)        
   end

   defp brackets_eval(list,acc) do
    index_of_ob=Enum.with_index(list) 
    |>Enum.filter_map(fn {x, _} -> x == "(" end, fn {_, i} -> i end) 
    |>Enum.reverse            
    
    list_tuple=List.to_tuple(list)
    operator_index=Enum.at(list,Enum.at(index_of_ob,0)+2)  
        leftString=Enum.at(list,Enum.at(index_of_ob,0)+1)
    rightString=Enum.at(list,Enum.at(index_of_ob,0)+3)
    leftVal =
    if is_bitstring(leftString) do
      if  Regex.match?(~r{[0-9]},leftString) do
        String.to_integer(leftString)
    end
   else
    leftString
    end
       rightVal=
       if is_bitstring(rightString) do
        if  Regex.match?(~r{[0-9]},rightString) do
          String.to_integer(rightString)
      end
     else
      rightString
      end
    total=
    cond do
      operator_index == "/" ->
        div(leftVal,rightVal)
      operator_index == "*" ->
        leftVal*rightVal
      operator_index == "+" ->
        leftVal+rightVal
      operator_index == "-" ->
        leftVal-rightVal
      true ->
        IO.puts("Invalid input")
        main()
    end
    acc=total+acc |> IO.inspect
    Tuple.delete_at(list_tuple,Enum.at(index_of_ob,0)) 
         |> Tuple.delete_at(Enum.at(index_of_ob,0))
         |> Tuple.delete_at(Enum.at(index_of_ob,0))
         |> Tuple.delete_at(Enum.at(index_of_ob,0))
         |> Tuple.delete_at(Enum.at(index_of_ob,0))
         |> Tuple.insert_at(Enum.at(index_of_ob,0) ,total)
         |> Tuple.to_list
         |> evaluate(acc)   

   end
end
