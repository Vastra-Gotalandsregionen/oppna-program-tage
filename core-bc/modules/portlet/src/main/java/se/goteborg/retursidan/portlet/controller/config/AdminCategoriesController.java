package se.goteborg.retursidan.portlet.controller.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import se.goteborg.retursidan.model.entity.Category;
import se.goteborg.retursidan.portlet.controller.BaseController;
import se.goteborg.retursidan.portlet.validation.CategoryValidator;

import javax.portlet.ActionResponse;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("EDIT")
public class AdminCategoriesController extends BaseController {
    Logger logger = LoggerFactory.getLogger(this.getClass().getName());

	@ModelAttribute("newCategory")
	public Category getNewCategory() {
		return new Category();
	}

	@ModelAttribute("removeCategory")
	public Category getRemoveCategory() {
		return new Category();
	}

	@Autowired
	private CategoryValidator categoryValidator;
	
	@InitBinder("newCategory")  
	protected void initBinderCategory(WebDataBinder binder) {  
		binder.setValidator(categoryValidator);  
	}
	
	@RenderMapping(params="page=adminCategories")
	public String changeCategories(Model model) {
		List<Category> topCategories = modelService.getTopCategories();
		model.addAttribute("topCategories", topCategories);

		Map<Integer, List<Category>> subCatList = new HashMap<Integer, List<Category>>();
		for (Category category : topCategories) {
			List<Category> subCategories = modelService.getSubCategories(category.getId());
			subCatList.put(category.getId(), subCategories);
		}
		model.addAttribute("subCategories", subCatList);
		
		return "config/admin_categories";
	}
	
	@ActionMapping("saveCategory")
	public void saveUnit(@Valid @ModelAttribute("newCategory") Category category, BindingResult bindingResult, ActionResponse response, Model model) {
		if (!bindingResult.hasErrors()) {
			modelService.addCategory(category);			
			// clear the newCategory model attribute so that the input box is empty
			model.addAttribute("newCategory", new Category());
		}
		response.setRenderParameter("page", "adminCategories");
	}
	
	@ActionMapping("removeCategory")
	public void removeUnit(@ModelAttribute("removeCategory") Category category, ActionResponse response, Model model) {
		modelService.removeCategory(category);
		response.setRenderParameter("page", "adminCategories");
	}
}
