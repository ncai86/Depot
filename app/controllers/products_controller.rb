class ProductsController < ApplicationController
  def index
     @products = Product.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @products }
      end
  end

  def edit
    @product = Product.find(params[:id])
  end
  
  def update
   @product = Product.find(params[:id])
   
   respond_to do |format|
     if @product.update_attributes(params[:product])
       format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
       format.xml  { head :ok }
     else
       format.html { render :action => "edit"}
       format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
     end
   end
  end
  
    
  

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end
  
  def create
      @product = Product.new(params[:product])

      respond_to do |format|
        if @product.save
          format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
          format.xml  { render :xml => @product, :status => :created, :location => @product }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        end
      end
    end
    
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    
   respond_to do |format|
        #redirect_to requires routename_url param
        format.html { redirect_to(products_url) }
        format.xml  { head :ok }
      end
    end
end
