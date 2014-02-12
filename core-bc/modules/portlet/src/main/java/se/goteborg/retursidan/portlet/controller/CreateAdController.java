package se.goteborg.retursidan.portlet.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import se.goteborg.retursidan.model.entity.Advertisement;
import se.goteborg.retursidan.model.entity.Category;
import se.goteborg.retursidan.model.entity.Unit;
import se.goteborg.retursidan.portlet.binding.PhotoListPropertyEditor;
import se.goteborg.retursidan.portlet.validation.AdValidator;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.validation.Valid;
import java.util.List;
import java.util.logging.Level;

/**
 * Controller handling creating ads
 *
 */
@Controller
@RequestMapping("VIEW")
public class CreateAdController extends BaseController {
    Logger logger = LoggerFactory.getLogger(this.getClass().getName());


    @InitBinder("advertisement")
	public void initBinder(WebDataBinder binder) {
		binder.setValidator(new AdValidator());
		binder.registerCustomEditor(List.class, "photos", new PhotoListPropertyEditor());	
	}

	@ModelAttribute("advertisement")
	public Advertisement createAdvertisement() {
		return new Advertisement();
	}
		
	@RenderMapping(params="page=createAdConfirm")
	public String render(Model model) {		
		return "create_ad_confirm";
	}

	
	@RenderMapping(params="page=createAd")
	public String createAd(Model model) {
		// work-around for Spring form bug/misbehavior, errors are not persisted in model 
		Advertisement advertisement;
		if(model.containsAttribute("advertisement")) {
			advertisement = (Advertisement)model.asMap().get("advertisement");
		} else {
			advertisement = new Advertisement();
		}
		
		List<Unit> units = modelService.getUnits();
		model.addAttribute("units", units);
	
		List<Category> topCategories = modelService.getTopCategories();
		model.addAttribute("topCategories", topCategories);

		if (advertisement.getTopCategory() != null && advertisement.getTopCategory().getId() > 0) {
			List<Category> subCategories = modelService.getSubCategories(advertisement.getTopCategory().getId());
			model.addAttribute("subCategories", subCategories);		
		}
			
		return "create_ad";
	}

	@ActionMapping("saveAd")
	public void saveAd(@Valid @ModelAttribute("advertisement") Advertisement advertisement, BindingResult bindingResult,
                       ActionRequest request, ActionResponse response, Model model) {
		advertisement.setCreatorUid(getUserId(request));
		if (!bindingResult.hasErrors()) {
			logger.trace("Saving advertisement: " + advertisement);
			advertisement.setStatus(Advertisement.Status.PUBLISHED);
			int id = modelService.saveAd(advertisement);
			logger.trace("Advertisement saved with id = " + id);
			
			// reload the ad into the model to get all data populated
			model.addAttribute("advertisement", modelService.getAdvertisement(id));
			response.setRenderParameter("page", "viewAd");
		} else {
			response.setRenderParameter("page", "createAd");			
		}
	}	
}
