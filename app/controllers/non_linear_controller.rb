require 'json'
class NonLinearController < ApplicationController
  def solve
  end

  def solveEquation
    equation=String.new(params[:input].to_str)
    validate=validateInput(params[:input])
    if validate.eql?(0)
      input=String.new(mathConcat(equation))
      puts input
      output = {'result'=>'success','solution' => eval(input).inspect}.to_json
      render :json => output
    else
        output = {'result'=>'error','solution' => 'error, we are input not valid equation'}.to_json
        render :json => output
    end
    
  end

  def parseInput(exp)
  	return eval(expression).inspect
	rescue => e
		#return e.to_s + "\n" + e.backtrace.join("\n")
		return "fail"
  	
  end

  def validateInput(input)
    regexp=Regexp.new('((x|PI|exp|sin|cos|tan|log10|log|asin|acos|atan|sinh|cosh|tanh|cth|asinh|acosh|atanh)(?=\())+')
    parse=input.gsub!(regexp,'')
    if parse.eql?(nil)
      parse=input
    end
    return parse.scan(/[a-zA-Z]+/).size
  end
  
  def mathConcat(input)
    regexp=Regexp.new('((sin|cos|tan|log10|log|asin|acos|atan|sinh|cosh|tanh|cth|asinh|acosh|atanh)(?=\())+')
    matcher=input.scan(regexp)
    parse=String.new("")
    matcher.each do|n|
      parse=input.gsub!(n[0],'Math.'+n[0])
    end
    return parse
  end  

end
