require 'json'
class NonLinearController < ApplicationController
  def solve
  end

  @@accuracy = 0.0000000001
  @@max_iter = 100000

  def solveEquation
    equation=String.new(params[:input].to_str)
    validate=validateInput(params[:input])
    begin
      if validate.eql?(0)
        input=String.new(mathConcat(equation))
        input = intToFloat(input)
        puts params
        if(input.match(/\bx\b/).eql?(nil))
          puts input.match(/\bx\b/)
          output = {'result'=>'error','solution' => 'Wrong equation format.'}.to_json
          render :json => output
          return
        end
        begin
          if(params[:method] == "bisection")
            x = calculateBisection(input, Float(params[:lower_bound]), Float(params[:upper_bound]))
          else
            x = calculateSecant(input, Float(params[:lower_bound]), Float(params[:upper_bound]))
          end
        rescue ArgumentError => ex
          output = {'result'=>'error','solution' => ex.message}.to_json
          render :json => output
          return
        end
        answer = x.to_s + ', accuracy = ' + @@accuracy.to_s
        output = {'result'=>'success','solution' => answer}.to_json
        render :json => output
      else
          output = {'result'=>'error','solution' => 'Wrong equation format.'}.to_json
          render :json => output
      end
    rescue Exception => e
      puts e.method
      puts e.backtrace
      output = {'result'=>'error','solution' => 'Wrong equation format.'}.to_json
      render :json => output
    end
    
  end

  def calculateBisection(expression,a,b)
    xn1 = a
    xn = Float(eval(expression.gsub(/x/,xn1.to_s)).inspect).abs
    iter = 0
    while(iter < @@max_iter && Float(eval(expression.gsub(/x/,xn.to_s)).inspect).abs >= @@accuracy)
       xn = Float((a+b)/2)
       tmpres = Float(eval(expression.gsub(/x/, xn.to_s)).inspect)
       tmpa = Float(eval(expression.gsub(/x/,a.to_s)).inspect)
      if (tmpres*tmpa < 0)
        b = xn
      else
        a = xn
      end
      iter +=1
    end
    if(iter >= @@max_iter)
      raise ArgumentError, "Thousands of iterations were made, but we didn't find a root. It may be complex or maybe there is no root on the given interval or maybe there are several roots."
    end
    return xn
  end


  def calculateSecant(expression, a,b)
    xn0 = a
    xn = b
    yn = Float(eval(expression.gsub(/x/,xn.to_s)).inspect)
    yn0 = Float(eval(expression.gsub(/x/,xn0.to_s)).inspect)
    if(yn0 == yn)
      yn0 = yn + 0.00000000001
    end
    xn1 = xn - yn*(xn-xn0)/(yn-yn0)
    iter = 0
    while(iter < @@max_iter && Float(eval(expression.gsub(/x/,xn1.to_s)).inspect).abs >= @@accuracy && xn1 >= a && xn1 <= b)
      xn0 = xn
      xn = xn1
      yn = Float(eval(expression.gsub(/x/,xn.to_s)).inspect)
      yn0 = Float(eval(expression.gsub(/x/,xn0.to_s)).inspect)
      xn1 = xn - yn*(xn-xn0)/(yn-yn0)
      iter +=1
    end
    if(iter >= @@max_iter)
      raise ArgumentError, "Thousands of iterations were made, but we didn't find a root. It may be complex or maybe there is no root on the given interval or maybe there are several roots."
    end
    return xn1
  end

  def validateInput(input)
    regexp=Regexp.new('((\+|-|\*|\^|\\|x|PI|exp|sin|cos|tan|log10|log|asin|acos|atan|sinh|cosh|tanh|cth|asinh|acosh|atanh)(?=\())+')
    puts input
    parse=input.gsub!(regexp,'')
    if parse.eql?(nil)
      parse=input
    end
    return parse.scan(/[a-waA-WyzYZ]+/).size
  end
  
  def mathConcat(input)
    regexp=Regexp.new('((sin|cos|tan|log10|log|asin|acos|atan|sinh|cosh|tanh|cth|asinh|acosh|atanh)(?=\())+')
    input = input.gsub(/\^/,"**")
    matcher=input.scan(regexp)
    parse=String.new("")
    matcher.each do|n|
      parse=input.gsub!(n[0],'Math.'+n[0])
    end
    if parse.empty?
      return input
    end
    return parse
  end  

  def intToFloat(input)
    regexp=/(\b\d+\.?\d*\b)+/
    matcher=input.scan(regexp)
    parse=""
    matcher.each do|n|
      if(!n.to_s.include?'.')
        puts "n = #{n}, n[0] = #{n[0]}"
        parse=input.gsub!(/\b#{n[0]}\b/,n[0]+".to_f")
      end
    end
    if (parse.length > 0)
      return parse
    else
      return input
    end
  end

end