package se.goteborg.retursidan.service;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.List;
import java.util.function.Function;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.BooleanUtils;
import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import se.goteborg.retursidan.dao.AdvertisementDAO;
import se.goteborg.retursidan.dao.AreaDAO;
import se.goteborg.retursidan.dao.CategoryDAO;
import se.goteborg.retursidan.dao.PersonDAO;
import se.goteborg.retursidan.dao.PhotoDAO;
import se.goteborg.retursidan.dao.RequestDAO;
import se.goteborg.retursidan.dao.UnitDAO;
import se.goteborg.retursidan.model.PagedList;
import se.goteborg.retursidan.model.PhotoHolder;
import se.goteborg.retursidan.model.entity.Advertisement;
import se.goteborg.retursidan.model.entity.Area;
import se.goteborg.retursidan.model.entity.Category;
import se.goteborg.retursidan.model.entity.Person;
import se.goteborg.retursidan.model.entity.Photo;
import se.goteborg.retursidan.model.entity.Request;
import se.goteborg.retursidan.model.entity.Unit;

import javax.imageio.ImageIO;
import javax.sql.rowset.serial.SerialBlob;

@Service
@Transactional(propagation = Propagation.REQUIRES_NEW)
public class ModelService {
	@Autowired
	private AdvertisementDAO advertisementDAO;
	
	@Autowired
	private RequestDAO requestDAO;
	
	@Autowired
	private CategoryDAO categoryDAO;

	@Autowired
	private UnitDAO unitDAO;

	@Autowired
	private AreaDAO areaDAO;

	@Autowired
	private PersonDAO personDAO;

	@Autowired
	private PhotoDAO photoDAO;

	
	public void addCategory(Category category) {
		if (category.getParent() != null && category.getParent().getId() == -1) {
			category.setParent(null);
		}
		categoryDAO.add(category);
	}
	public List<Category> getCategories() {
		return categoryDAO.findAll();
	}
	public List<Category> getTopCategories() {
		return categoryDAO.findTopCategories();
	}
	public List<Category> getSubCategories(int id) {
		return categoryDAO.findAllSubCategories(id);
	}

	public void addUnit(Unit unit) {
		unitDAO.add(unit);
	}
	public List<Unit> getUnits() {
		return unitDAO.findAll();
	}

	public void addArea(Area area) {
		areaDAO.add(area);
	}
	public List<Area> getAreas() {
		return areaDAO.findAll();
	}

	public void addPerson(Person person) {
		personDAO.add(person);
	}
	
	public void addPhoto(Photo photo) {
		photoDAO.add(photo);
	}
	public Photo getPhoto(int id) {
        return photoDAO.findById(id);
    }

    public PhotoHolder getPhotoHolder(Integer id, boolean thumbnail) {
        Photo photo = getPhoto(id);

        if (photo == null) {
            return null;
        }

        Blob image = (thumbnail) ? photo.getThumbnail() : photo.getImage();

        PhotoHolder photoHolder = new PhotoHolder();
        photoHolder.setImage(image);
        photoHolder.setMimeType(photo.getMimeType());
        try {
            photoHolder.setImageLength(image.length());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return photoHolder;
    }

    public void copyPhotoStream(Integer id, OutputStream os, boolean thumbnail) {
        PhotoHolder photoHolder = getPhotoHolder(id, thumbnail);

        try {
            IOUtils.copyLarge(photoHolder.getImage().getBinaryStream(), os);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void removePhoto(Photo photo) {
		photoDAO.delete(photo);
	}
	public List<Photo> getAllPhotos() {
		return photoDAO.findAll();
	}	
	
	public Category getCategory(int id) {
		return categoryDAO.findById(id);
	}
	
	
	public void addAdvertisement(Advertisement advertisement) {
		advertisementDAO.add(advertisement);
	}
	public Advertisement getAdvertisement(int id) {
		return advertisementDAO.findById(id);
	}
	public PagedList<Advertisement> getAllFilteredAdvertisements(Advertisement.Status status, Category topCategory, Category category, Unit unit, Area area, Boolean hidden, int page, int pageSize) {
		return advertisementDAO.find(null, status, topCategory, category, unit, area, hidden, false, page, pageSize);
	}
	public PagedList<Advertisement> getAllAdvertisements(Advertisement.Status status, Boolean hidden, int page, int pageSize) {
		return advertisementDAO.find(null, status, null, null, null, null, hidden, false, page, pageSize);
	}
	public PagedList<Advertisement> getAllAdvertisementsForUid(String uid, Boolean hidden, int page, int pageSize) {
		return advertisementDAO.find(uid, null, null, null, null, null, hidden, false, page, pageSize);
	}
	public PagedList<Advertisement> getAllFilteredAdvertisementsForUid(String uid, Category topCategory, Category category, Unit unit, Area area, Boolean hidden, int page, int pageSize) {
		return advertisementDAO.find(uid, null, topCategory, category, unit, area, hidden, false, page, pageSize);
	}
	
	public void removeAdvertisement(Advertisement advertisement) {
		advertisementDAO.delete(advertisement);
	}
	
	public void addRequest(Request request) {
		requestDAO.add(request);
	}
	public Request getRequest(int id) {
		return requestDAO.findById(id);
	}
	
	public int saveRequest(Request request) {
		return requestDAO.add(request);
	}
	public PagedList<Request> getAllRequests(int page, int pageSize) {
		return requestDAO.find(null, page, pageSize);
	}
	
	public int saveAd(Advertisement ad) {
		return advertisementDAO.add(ad);
	}

	
	public void updateAd(Advertisement ad) {
		advertisementDAO.update(ad);
	}

	
	public void updateRequest(Request request) {
		requestDAO.update(request);
	}

	public Person getPerson(String uid) {
		return personDAO.findByUid(uid);
	}
	public void removeRequest(Request request) {
		requestDAO.delete(request);
	}
	public List<Request> getAllRequests(Request.Status status) {
		return requestDAO.findAll(status);
	}
	public void removeUnit(Unit unit) {
		unitDAO.delete(unit);
	}
	public void removeArea(Area area) {
		areaDAO.delete(area);
	}
	public void removeCategory(Category category) {
		categoryDAO.delete(category);
	}

	public void hideAdvertisement(Integer advertisementId, Boolean markAsBooked) {
		Advertisement ad = advertisementDAO.findById(advertisementId);
		ad.setHidden(true);

		if (BooleanUtils.isTrue(markAsBooked)) {
			ad.setStatus(Advertisement.Status.BOOKED);
		}

		advertisementDAO.update(ad);
	}

	public void rotatePhoto(Integer id, Function<BufferedImage, BufferedImage> postTransformFunction) {
		Photo photo = getPhoto(id);
		if (photo != null) {
			BufferedImage image = null;
			try {
				image = ImageIO.read(photo.getImage().getBinaryStream());
				BufferedImage thumbnail = ImageIO.read(photo.getThumbnail().getBinaryStream());
				rotateImage(photo, image, thumbnail, postTransformFunction);
			} catch (IOException | SQLException e) {
				throw new RuntimeException(e);
			}
		}
	}

	private void rotateImage(Photo photo, BufferedImage image, BufferedImage thumbnail, Function<BufferedImage,
			BufferedImage> postTransformFunction) throws IOException, SQLException {

		BufferedImage rotated = Scalr.rotate(image, Scalr.Rotation.CW_90);
		BufferedImage rotatedThumbnail = Scalr.rotate(thumbnail, Scalr.Rotation.CW_90);

		if (postTransformFunction != null) {
			rotated = postTransformFunction.apply(rotated);
		}

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ImageIO.write(rotated, "png", baos);

		photo.setImage(new SerialBlob(baos.toByteArray()));

		baos = new ByteArrayOutputStream();
		ImageIO.write(rotatedThumbnail, "png", baos);

		photo.setThumbnail(new SerialBlob(baos.toByteArray()));

		addPhoto(photo);
	}

}
