package com.aespen.stickynotes.web;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;

import android.accounts.NetworkErrorException;
import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;
import android.webkit.WebIconDatabase.IconListener;
import android.widget.Toast;

import com.aespen.stickynotes.Login;
import com.aespen.stickynotes.dao.ICallbackListner;
import com.aespen.stickynotes.dao.Note;
import com.aespen.stickynotes.dao.User;
import com.squareup.okhttp.OkHttpClient;


public class WebConnectionDelegate
{
	public ICallbackListner listner;
	
	private static OkHttpClient client = new OkHttpClient();
	
	private static final String BASE_URL = "http://stickyapi.alanedwardes.com/";
	
	public void login(final String username, final String password) throws NetworkErrorException, IOException, JSONException
	{
		new AsyncTask<Void, Void, JSONObject>() {

			@Override
			protected JSONObject doInBackground(Void... params) {
				try {
					Map <String,String> parameters =  new HashMap<String,String>();
					parameters.put("username", username);
					parameters.put("password", password);
					
					JSONObject jsonObject = (JSONObject) WebConnectionDelegate.postJsonAtPath("api/login", parameters);
					
					return jsonObject;
//					return jsonObject.optString("user");
				} catch (NetworkErrorException e) {
					Log.v("Error",e.toString());
//					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} catch (JSONException e) {
					e.printStackTrace();
				}
				return null;
			}
		
			protected void onPostExecute(final JSONObject result) {
				if (result != null) {
					if(listner != null) {
						listner.callback(result);
					}
				}
			};
		}.execute();
	}
	
	public static void uploadNoteToWebService(final Note note) throws NetworkErrorException, IOException, JSONException
	{
		new AsyncTask<Void, Void, String>() {

			@Override
			protected String doInBackground(Void... params) {
				try {
					Map <String,String> parameters =  new HashMap<String,String>();
					parameters.put("id", note.getId().toString());
					parameters.put("author", note.getAuthor().toString());
					parameters.put("text", note.getText().toString());
					parameters.put("created", note.getCreated().toString());
					parameters.put("user_id", note.getUser().getId().toString());
					
					JSONObject jsonObject = (JSONObject) WebConnectionDelegate.postJsonAtPath("api/note", parameters);
					
					return jsonObject.toString();
//					return jsonObject.optString("user");
				} catch (NetworkErrorException e) {
					Log.v("Error",e.toString());
//					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} catch (JSONException e) {
					e.printStackTrace();
				}
				return null;
			}
		
			protected void onPostExecute(String result) {
				if (result != null) {
//					Toast.makeText(Login.this, "POST : " + result, Toast.LENGTH_SHORT).show();
				}
			};
			
			
		}.execute();
	}
	
	@SuppressLint("NewApi")
	public Object getJsonAtPath(String path, Map<String, String> parameters) throws IOException,
	NetworkErrorException, JSONException
	{
		String url = path + mapToQueryString(parameters);
		Log.e("", url);
		HttpURLConnection connection = client.open(getUrl(url));
		InputStream in = null;
		try
		{
			//Write the request.
			connection.setRequestMethod("GET");

			connection.addRequestProperty("Accept", "application/json");
			connection.addRequestProperty("Content-Type", "application/json");


			//Read the response.
			if (connection.getResponseCode() != HttpURLConnection.HTTP_OK)
			{
				in = connection.getErrorStream();
				byte[] response = readFully(in);
				String responseString = new String(response, "UTF-8");

				throw new NetworkErrorException("Unexpected HTTP response: "
						+ connection.getResponseCode() + ": " + connection.getResponseMessage()
						+ " \n " + responseString + "\n Params: "
						+ ((parameters == null) ? "null" : parameters.toString()));
			}
			in = connection.getInputStream();
			byte[] response = readFully(in);
			String responseString = new String(response, "UTF-8");
			return new JSONObject(responseString);
		}
		finally
		{
			//Clean up.
			if (in != null) in.close();
		}
	}

	public static Object postJsonAtPath(String path, Map<String, String> parameters) throws IOException,
	NetworkErrorException, JSONException
	{

		JSONObject params = mapStringToJsonObject(parameters);

		HttpURLConnection connection = client.open(getUrl(path));
		OutputStream out = null;
		InputStream in = null;
		try
		{
			//Write the request.
			connection.setRequestMethod("POST");

			connection.addRequestProperty("Accept", "application/json");
			connection.addRequestProperty("Content-Type", "application/json");

			out = connection.getOutputStream();

			if (params != null)
			{
				byte[] body = params.toString()
						.getBytes("UTF-8");
				out.write(body);
			}

			out.close();

			//Read the response.
			if (connection.getResponseCode() != HttpURLConnection.HTTP_OK && connection.getResponseCode() != HttpURLConnection.HTTP_CREATED)
			{
				in = connection.getErrorStream();
				byte[] response = readFully(in);
				String responseString = new String(response, "UTF-8");

				throw new NetworkErrorException("\n\nUnexpected HTTP response: "
						+ connection.getResponseCode() + ": " + connection.getResponseMessage()
						+ " \n " + responseString + "\n Params: "
						+ ((params == null) ? "null" : params.toString()));
			}
			in = connection.getInputStream();
			byte[] response = readFully(in);
			String responseString = new String(response, "UTF-8");

			return new JSONObject(responseString);
		}
		finally
		{
			//Clean up.
			if (out != null) out.close();
			if (in != null) in.close();
		}
	}

	private static JSONObject mapStringToJsonObject(Map<String, String> parameters) throws JSONException
	{
		JSONObject params = new JSONObject();
		for (Map.Entry<String, String> entry : parameters.entrySet())
		{
			params.put(entry.getKey(), entry.getValue());
		}
		return params;
	}

	private JSONObject mapToJsonObject(Map<String, Object> parameters) throws JSONException
	{
		JSONObject params = new JSONObject();
		for (Map.Entry<String, Object> entry : parameters.entrySet())
		{
			Object value = entry.getValue();
			if (value instanceof Map)
			{
				params.put(entry.getKey(), mapToJsonObject((Map<String, Object>) value));
			}
			else
			{
				params.put(entry.getKey(), value);
			}
		}
		return params;
	}

	private String mapToQueryString(Map<String, String> parameters) throws JSONException
	{
		String string = "?";
		for (Map.Entry<String, String> entry : parameters.entrySet())
		{
			try {
				string += URLEncoder.encode(entry.getKey(), "UTF-8") + "=" + URLEncoder.encode(entry.getValue(), "UTF-8") + "&";
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return string;
	}


	public Bitmap getBitmapAtPath(String path) throws IOException, NetworkErrorException
	{
		HttpURLConnection connection = client.open(new URL(path));
		InputStream in = null;
		try
		{
			//Write the request.
			connection.setRequestMethod("GET");

			//Read the response.
			if (connection.getResponseCode() != HttpURLConnection.HTTP_OK)
			{
				throw new NetworkErrorException("Unexpected HTTP response: "
						+ connection.getResponseCode() + " " + connection.getResponseMessage());
			}
			in = connection.getInputStream();
			return BitmapFactory.decodeStream(in);
		}
		finally
		{
			if (in != null) in.close();
		}
	}

	private static final URL getUrl(String path) throws MalformedURLException
	{
		return new URL(BASE_URL + path);
	}
	
	private static final byte[] readFully(InputStream in) throws IOException
	{
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		for (int count; (count = in.read(buffer)) != -1;)
		{
			out.write(buffer, 0, count);
		}
		return out.toByteArray();
	}

	public void postFileToPath(String path, String filePath, Map<String, Object> params)
			throws IOException, NetworkErrorException, JSONException
			{

		HttpClient httpclient = new DefaultHttpClient();
		HttpPost httppost = new HttpPost("URL" + path);

		MultipartEntity multipartEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
		multipartEntity.addPart("Filedata", new FileBody(new File(filePath)));

		for (Map.Entry<String, Object> entry : params.entrySet())
		{
			multipartEntity.addPart(entry.getKey(), new StringBody((String) entry.getValue()));
		}

		httppost.setEntity(multipartEntity);

		ResponseHandler<String> responseHandler = new BasicResponseHandler();
		try
		{
			httpclient.execute(httppost, responseHandler);
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
			}
}
